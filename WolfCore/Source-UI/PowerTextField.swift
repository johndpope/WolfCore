//
//  PowerTextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/12/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit


private protocol TextEditor: class {
    var inputView: UIView? { get set }
    var text: String! { get set }
    var font: UIFont? { get set }
    var isDebug: Bool { get set }
    var debugBackgroundColor: UIColor? { get set }
    var textAlignment: NSTextAlignment { get set }
    var fontStyleName: FontStyleName? { get set }

    // UITextInputTraits
    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var autocorrectionType: UITextAutocorrectionType { get set }
    var spellCheckingType: UITextSpellCheckingType { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var enablesReturnKeyAutomatically: Bool { get set }
    var isSecureTextEntry: Bool { get set }

    @available(iOS 10.0, *)
    var textContentType: UITextContentType! { get set }
}

extension TextField: TextEditor { }

extension TextView: TextEditor { }

public class PowerTextField: View, Editable {
    public init(contentType: ContentType = .text, numberOfLines: Int = 1) {
        self.contentType = contentType
        self.numberOfLines = numberOfLines
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var isEditing: Bool = false

    public enum ContentType {
        case text
        case social
        case date
        case email
        case password
    }

    public private(set) var contentType: ContentType
    public private(set) var numberOfLines: Int

    public var textAlignment: NSTextAlignment = .natural {
        didSet {
            syncToAlignment()
        }
    }

    public override var inputView: UIView? {
        get {
            return textEditor.inputView
        }

        set {
            textEditor.inputView = newValue
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

    public var editValidator: StringEditValidator?
    public var submitValidator: StringSubmitValidator?

    public var text: String? {
        get {
            return textEditor.text
        }
    }

    public func setText(_ text: String?, animated: Bool) {
        textEditor.text = text
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

    public var showsValidationMessage: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var characterCountTemplate = "#{characterCount}/#{characterLimit}"

    private var characterCountString: String {
        return characterCountTemplate ¶ ["characterCount": String(characterCount), "characterLimit": characterLimit†, "charactersLeft": charactersLeft†]
    }

    private func syncToShowsValidationMessage() {
        switch showsValidationMessage {
        case false:
            validationMessageLabel.hide()
        case true:
            validationMessageLabel.show()
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

    fileprivate func updateCharacterCount() {
        characterCountLabel.text = characterCountString
    }

    public var validatedText: String?

    public var validationError: ValidationError? {
        willSet {
            if validationError != nil && newValue == nil {
                dispatchAnimated(options: .beginFromCurrentState) {
                    self.validationMessageLabel.alpha = 0
                }.run()
            }
        }

        didSet {
            if let validationError = validationError {
                validationMessageLabel.text = validationError.message
                if oldValue == nil {
                    dispatchAnimated(options: .beginFromCurrentState) {
                        self.validationMessageLabel.alpha = 1
                    }.run()
                }
            }
        }
    }

    public var disallowedCharacters: CharacterSet? = CharacterSet.controlCharacters
    public var allowedCharacters: CharacterSet?

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textEditor.autocapitalizationType }
        set { textEditor.autocapitalizationType = newValue }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get { return textEditor.spellCheckingType }
        set { textEditor.spellCheckingType = newValue }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { return textEditor.autocorrectionType }
        set { textEditor.autocorrectionType = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { return textEditor.returnKeyType }
        set { textEditor.returnKeyType = newValue }
    }

    public var enablesReturnKeyAutomatically: Bool {
        get { return textEditor.enablesReturnKeyAutomatically }
        set { textEditor.enablesReturnKeyAutomatically = newValue }
    }

    public private(set) var isSecureTextEntry: Bool {
        get { return textEditor.isSecureTextEntry }
        set { textEditor.isSecureTextEntry = newValue }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        get { return textEditor.textContentType }
        set { textEditor.textContentType = newValue }
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

    private lazy var topRowView: HorizontalStackView = {
        let view = HorizontalStackView()
        view.alignment = .center
        return view
    }()

    private lazy var bottomRowView: HorizontalStackView = {
        let view = HorizontalStackView()
        view.alignment = .center
        return view
    }()

    public var frameColor: UIColor {
        get {
            return frameView.color
        }
        set {
            frameView.color = newValue
        }
    }

    public var frameMode: FrameView.Mode {
        get {
            return frameView.mode
        }

        set {
            frameView.mode = newValue
        }
    }

    public var frameLineWidth: CGFloat {
        get {
            return frameView.lineWidth
        }

        set {
            frameView.lineWidth = newValue
        }
    }

    private lazy var frameView: FrameView = {
        let view = FrameView()
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

    private lazy var validationSpacerView: SpacerView = {
        let view = SpacerView()
        view.width = self.frameInsets.left
        return view
    }()

    private lazy var validationMessageLabel: Label = {
        let label = Label()
        label.text = " "
        label.alpha = 0
        return label
    }()

    private lazy var placeholderLabel: Label = {
        let label = Label()
        label.numberOfLines = 0
        return label
    }()

    private lazy var textEditorView: UIView = {
        let needsTextField = self.contentType == .password
        let needsTextView = self.numberOfLines > 1
        assert(!needsTextField || !needsTextView)
        if needsTextView {
            return self.textView
        } else {
            return self.textField
        }
    }()

    private var textEditor: TextEditor {
        return textEditorView as! TextEditor
    }

    private var textChangedAction: ControlAction<TextField>!
    private lazy var textField: TextField = {
        let view = TextField()
        self.textChangedAction = addControlAction(to: view, for: .editingChanged) { [unowned self] field in
            self.syncToTextView(animated: true)
        }
        view.delegate = self
        return view
    }()

    private lazy var textView: TextView = {
        let view = TextView()
        view.contentInset = .zero
        view.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        view.scrollsToTop = false
        view.delegate = self
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
            validationMessageLabel.isDebug = isDebug
            textEditor.isDebug = isDebug
            iconView.isDebug = isDebug
            clearButtonView.isDebug = isDebug

            debugBackgroundColor = .green
            frameView.debugBackgroundColor = .blue
            characterCountLabel.debugBackgroundColor = .gray
            validationMessageLabel.debugBackgroundColor = .red
            textEditor.debugBackgroundColor = .green
            iconView.debugBackgroundColor = .blue
            clearButtonView.debugBackgroundColor = .blue
        }
    }

    private var frameInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    private func build() {
        syncToContentType()
        self => [
            verticalStackView => [
                topRowView => [
                    validationSpacerView,
                    validationMessageLabel
                    ],
                frameView => [
                    horizontalStackView => [
                        iconView,
                        textEditorView,
                        clearButtonView
                    ]
                ],
                bottomRowView => [
                    characterCountLabel
                    ]
            ],
            placeholderLabel
        ]

        //activateConstraints([widthAnchor == 200 =&= UILayoutPriorityDefaultLow])
        activateConstraint(frameView.widthAnchor == verticalStackView.widthAnchor)
        verticalStackView.constrainFrame()
        horizontalStackView.constrainFrame(insets: frameInsets)
        textViewHeightConstraint = textEditorView.constrainHeight(to: 20)
        activateConstraints(
            placeholderLabel.leadingAnchor == textEditorView.leadingAnchor,
            placeholderLabel.trailingAnchor == textEditorView.trailingAnchor,
            placeholderLabel.topAnchor == textEditorView.topAnchor,
            textEditorView.heightAnchor >= clearButtonView.heightAnchor
        )

        syncClearButton(animated: false)
        //isDebug = true
    }

    public override func setup() {
        super.setup()
        build()
    }

    private var textViewHeightConstraint: NSLayoutConstraint!

    private var lineHeight: CGFloat {
        return textEditor.font?.lineHeight ?? 20
    }

    public override func updateConstraints() {
        super.updateConstraints()

        syncToIcon()
        syncToShowsValidationMessage()
        syncToShowsCharacterCount()
        syncToFont()
    }

    public override func updateAppearance(skin: Skin?) {
        super.updateAppearance(skin: skin)
        guard let skin = skin else { return }
        textEditor.fontStyleName = .textFieldContent
        characterCountLabel.fontStyleName = .textFieldCounter
        validationMessageLabel.fontStyleName = .textFieldValidationMessage
        placeholderLabel.fontStyleName = .textFieldPlaceholder
        iconView.tintColor = skin.textFieldIconTintColor
        frameColor = skin.textFieldFrameColor
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

    private func syncToFont() {
        textViewHeightConstraint.constant = ceil(lineHeight * CGFloat(numberOfLines))
    }

    private func concealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 0
        }.run()
    }

    private func revealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 1
        }.run()
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
        case .social, .email:
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
        case .date:
            datePicker = UIDatePicker()
        case .password:
            isSecureTextEntry = true
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
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
        textEditor.textAlignment = textAlignment
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
            (textEditorView as? TextView)?.setContentOffset(.zero, animated: true)
            if validationError == nil {
                restartValidationTimer()
            }
            onEndEditing?(self)
        }
        syncToTextView(animated: animated)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        syncToAlignment()
    }

    private var validationTimer: Cancelable?
    private func restartValidationTimer() {
        guard submitValidator != nil else { return }
        cancelValidationTimer()
        validationTimer = dispatchOnMain(afterDelay: 1.0) {
            self.validate()
        }
    }

    private func cancelValidationTimer() {
        validationTimer?.cancel()
        validationTimer = nil
        validationError = nil
    }

    private func validate() {
        guard let submitValidator = submitValidator else {
            validatedText = text
            return
        }

        cancelValidationTimer()
        do {
            validatedText = try submitValidator(text)
            validationError = nil
        } catch let error as ValidationError {
            validatedText = nil
            validationError = error
        } catch let error {
            validatedText = nil
            logError(error)
        }
    }

    fileprivate func shouldChange(from startText: String, in range: NSRange, replacementText text: String) -> Bool {
        func _shouldChange() -> Bool {
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
            let replacedString = startText.replacingCharacters(in: startText.stringRange(from: range)!, with: text)

            // Enforce the character limit, if any
            if let characterLimit = characterLimit {
                guard replacedString.characters.count <= characterLimit else { return false }
            }

            if let editValidator = editValidator {
                if let _ = editValidator(replacedString) {
                    return true
                } else {
                    return false
                }
            }
            
            return true
        }

        let result = _shouldChange()
        if result {
            restartValidationTimer()
        }
        return result
    }
}

extension PowerTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setEditing(true, animated: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        setEditing(false, animated: true)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startText = textField.text ?? ""
        return shouldChange(from: startText, in: range, replacementText: string)
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
        let startText = textView.text ?? ""
        return shouldChange(from: startText, in: range, replacementText: text)
    }
}
