//
//  PowerTextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/12/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class PowerTextField: View, Editable {
    public var isEditing: Bool = false

    public enum ContentType {
        case text
        case social
        case date
    }

    public var contentType: ContentType = .text {
        didSet {
            syncToContentType()
        }
    }

    public var textAlignment: NSTextAlignment = .natural {
        didSet {
            syncToAlignment()
        }
    }

    public override var inputView: UIView? {
        get {
            return textView.inputView
        }

        set {
            textView.inputView = newValue
        }
    }

    public var datePickerChangedAction: ControlAction<UIDatePicker>!

    public var datePicker: UIDatePicker! {
        didSet {
            inputView = datePicker
            datePickerChangedAction = addValueChangedAction(to: datePicker) { [unowned self] _ in
                self.syncTextToDate(animated: true)
            }
        }
    }

    private func syncTextToDate(animated: Bool) {
        let align = textAlignment
        if let date = date {
            setText(dateFormatter.string(from: date), animated: animated)
        } else {
            clear(animated: animated)
        }
        textAlignment = align
    }

    public var date: Date? {
        get {
            return datePicker?.date
        }

        set {
            if let date = newValue {
                datePicker.date = date
            }
        }
    }

    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    public var name: String = "Field"¶

    public typealias EditValidator = (_ string: String?, _ name: String) -> String?
    public var editValidator: EditValidator?

    public var numberOfLines: Int = 1

    public var text: String? {
        get {
            return textView.text
        }
    }

    public func setText(_ text: String?, animated: Bool) {
        textView.text = text
        syncToTextView(animated: false)
        onChanged?(self)
    }

    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }

        set {
            placeholderLabel.text = newValue
        }
    }

    public var icon: UIImage? {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var characterLimit: Int? {
        didSet {
            updateCharacterCount()
        }
    }

    public var characterCount: Int {
        return text?.characters.count ?? 0
    }

    public var isEmpty: Bool {
        return characterCount == 0
    }

    public var charactersLeft: Int? {
        guard let characterLimit = characterLimit else { return nil }
        return characterLimit - characterCount
    }

    public var showsCharacterCount: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var characterCountTemplate = "#{characterCount}/#{characterLimit}"

    private var characterCountString: String {
        return characterCountTemplate ¶ ["characterCount": String(characterCount), "characterLimit": characterLimit†, "charactersLeft": charactersLeft†]
    }

    fileprivate func updateCharacterCount() {
        characterCountLabel.text = characterCountString
    }

    public var disallowedCharacters: CharacterSet? = CharacterSet.controlCharacters
    public var allowedCharacters: CharacterSet?

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get { return textView.spellCheckingType }
        set { textView.spellCheckingType = newValue }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { return textView.autocorrectionType }
        set { textView.autocorrectionType = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { return textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }

    public var enablesReturnKeyAutomatically: Bool {
        get { return textView.enablesReturnKeyAutomatically }
        set { textView.enablesReturnKeyAutomatically = newValue }
    }

    public var isSecureTextEntry: Bool {
        get { return textView.isSecureTextEntry }
        set { textView.isSecureTextEntry = newValue }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        get { return textView.textContentType }
        set { textView.textContentType = newValue }
    }

    public enum ClearButtonMode {
        case never
        case whileEditing
        case unlessEditing
        case always
    }

    public var clearButtonMode: ClearButtonMode = .never {
        didSet {
            syncClearButton(animated: false)
        }
    }

    private func syncClearButton(animated: Bool) {
        switch clearButtonMode {
        case .never:
            clearButtonView.conceal(animated: animated)
        case .whileEditing:
            if isEditing && !isEmpty {
                clearButtonView.reveal(animated: animated)
            } else {
                clearButtonView.conceal(animated: animated)
            }
        case .unlessEditing:
            if isEditing {
                clearButtonView.conceal(animated: animated)
            } else {
                clearButtonView.reveal(animated: animated)
            }
        case .always:
            clearButtonView.reveal(animated: animated)
        }
    }

    public typealias ResponseBlock = (PowerTextField) -> Void
    public var onEndEditing: ResponseBlock?
    public var onChanged: ResponseBlock?

    private lazy var verticalStackView: VerticalStackView = {
        let view = VerticalStackView()
        view.alignment = .leading
        return view
    }()

    private lazy var frameView: View = {
        let view = View()
        //view.isTransparentToTouches = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    private lazy var horizontalStackView: HorizontalStackView = {
        let view = HorizontalStackView()
        view.spacing = 6
        view.alignment = .center
        return view
    }()

    private lazy var characterCountLabel: Label = {
        let label = Label()
        return label
    }()

    private lazy var placeholderLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        return label
    }()

    private lazy var textView: TextView = {
        let view = TextView()
        view.contentInset = .zero
        view.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        return view
    }()

    private lazy var iconView: ImageView = {
        let view = ImageView()
        view.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return view
    }()

    private var onClearAction: ControlAction<Button>!

    private lazy var clearButtonView: ClearFieldButtonView = {
        let view = ClearFieldButtonView()
        self.onClearAction = addTouchUpInsideAction(to: view.button) { [unowned self] _ in
            self.clear(animated: true)
        }
        return view
    }()

    public func clear(animated: Bool) {
        setText("", animated: animated)
    }

    public override var isDebug: Bool {
        didSet {
            frameView.isDebug = isDebug
            characterCountLabel.isDebug = isDebug
            textView.isDebug = isDebug
            iconView.isDebug = isDebug
            clearButtonView.isDebug = isDebug

            frameView.debugBackgroundColor = debugBackgroundColor
            characterCountLabel.debugBackgroundColor = debugBackgroundColor
            textView.debugBackgroundColor = debugBackgroundColor
            iconView.debugBackgroundColor = debugBackgroundColor
        }
    }

    public override func setup() {
        super.setup()
        textView.delegate = self

        textView.scrollsToTop = false

        self => [
            verticalStackView => [
                frameView => [
                    horizontalStackView => [
                        iconView,
                        textView,
                        clearButtonView
                    ]
                ],
                characterCountLabel
            ],
            placeholderLabel
        ]

        //activateConstraints([widthAnchor == 200 =&= UILayoutPriorityDefaultLow])
        activateConstraint(frameView.widthAnchor == verticalStackView.widthAnchor)
        verticalStackView.constrainFrame()
        horizontalStackView.constrainFrame(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        textViewHeightConstraint = textView.constrainHeight(to: 20)
        activateConstraints(
            placeholderLabel.leadingAnchor == textView.leadingAnchor,
            placeholderLabel.trailingAnchor == textView.trailingAnchor,
            placeholderLabel.topAnchor == textView.topAnchor
            )

        syncClearButton(animated: false)
        //isDebug = true
    }

    private var textViewHeightConstraint: NSLayoutConstraint!

    private var lineHeight: CGFloat {
        return textView.font?.lineHeight ?? 20
    }

    public override func updateConstraints() {
        super.updateConstraints()

        syncToIcon()
        syncToShowsCharacterCount()
        syncToFont()
    }

    public override func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)
        textView.fontStyleName = .textFieldContent
        characterCountLabel.fontStyleName = .textFieldCounter
        placeholderLabel.fontStyleName = .textFieldPlaceholder
        iconView.tintColor = skin?.textFieldIconTintColor
        syncToFont()
    }

    private func syncToIcon() {
        if let icon = icon {
            iconView.image = icon
            iconView.show()
        } else {
            iconView.hide()
        }
    }

    private func syncToShowsCharacterCount() {
        switch showsCharacterCount {
        case false:
            characterCountLabel.hide()
        case true:
            characterCountLabel.show()
        }
    }

    private func syncToFont() {
        textViewHeightConstraint.constant = ceil(lineHeight * CGFloat(numberOfLines))
    }

    private func concealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 0
        }
    }

    private func revealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 1
        }
    }

    fileprivate lazy var placeholderHider: Locker = {
        return Locker(onLocked: { [unowned self] in
            self.concealPlaceholder(animated: true)
            }, onUnlocked: { [unowned self] in
                self.revealPlaceholder(animated: true)
        })
    }()

    private func syncToContentType() {
        switch contentType {
        case .text:
            break
        case .social:
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
        case .date:
            datePicker = UIDatePicker()
        }
    }

    private lazy var keyboardNotificationActions = KeyboardNotificationActions()

    fileprivate var scrollToVisibleWhenKeyboardShows = false {
        didSet {
            if scrollToVisibleWhenKeyboardShows {
                keyboardNotificationActions.didShow = { [unowned self] _ in
                    self.scrollToVisible()
                }
            } else {
                keyboardNotificationActions.didShow = nil
            }
        }
    }

    private func scrollToVisible() {
        func doScroll() {
            for ancestor in allAncestors() {
                if let scrollView = ancestor as? UIScrollView {
                    let rect = convert(bounds, to: scrollView).insetBy(dx: -8, dy: -8)
                    scrollView.scrollRectToVisible(rect, animated: true)
                    break
                }
            }
        }

        dispatchOnMain(afterDelay: 0.05) {
            doScroll()
        }
    }

    fileprivate func syncToAlignment() {
        textView.textAlignment = textAlignment
        placeholderLabel.textAlignment = textAlignment
    }

    fileprivate func syncToTextView(animated: Bool) {
        syncClearButton(animated: animated)
        updateCharacterCount()
        placeholderHider["editing"] = isEditing
        placeholderHider["hasText"] = !isEmpty
        scrollToVisibleWhenKeyboardShows = isEditing
        syncToAlignment()
    }

    public func syncToEditing(animated: Bool) {
        if isEditing {
            scrollToVisible()
        } else {
            textView.setContentOffset(.zero, animated: true)
            onEndEditing?(self)
        }
        syncToTextView(animated: animated)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        syncToAlignment()
    }
}

extension PowerTextField: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setEditing(true, animated: true)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        setEditing(false, animated: true)
    }

    public func textViewDidChange(_ textView: UITextView) {
        syncToTextView(animated: true)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Don't allow any keyboard-based changes when entering dates
        guard contentType != .date else { return false }

        // Always allow deletions.
        guard text.characters.count > 0 else { return true }

        // If disallowedCharaters is provided, disallow any changes that include characters in the set.
        if let disallowedCharacters = disallowedCharacters {
            guard text.rangeOfCharacter(from: disallowedCharacters) == nil else { return false }
        }

        // If allowedCharacters is provided, disallow any changes that include characters not in the set.
        if let allowedCharacters = allowedCharacters {
            guard text.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
        }

        // Determine the final string
        let startText = textView.text ?? ""
        let replacedString = startText.replacingCharacters(in: startText.stringRange(from: range)!, with: text)

        // Enforce the character limit, if any
        if let characterLimit = characterLimit {
            guard replacedString.characters.count <= characterLimit else { return false }
        }

        if let editValidator = editValidator {
            if let _ = editValidator(replacedString, name) {
                return true
            } else {
                return false
            }
        }

        return true
    }
}
