//
//  EmailUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 5/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import MessageUI

public let mailComposer = MailComposer()

public class MailComposer: NSObject {
    private var viewController: MFMailComposeViewController!

    public func presentComposer(fromViewController presentingViewController: UIViewController, toRecipient recipient: String, subject: String, body: String? = nil) {
        guard !isSimulator else {
            presentingViewController.presentOKAlert(withMessage: "The simulator cannot send e-mail.", identifier: "notEmailCapable")
            return
        }

        guard MFMailComposeViewController.canSendMail() else {
            presentingViewController.presentOKAlert(withMessage: "Your device cannot send email."¶, identifier: "notEmailCapable")
            return
        }

        guard viewController == nil else {
            logError("There is already a mail composer active.")
            return
        }

        viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients([recipient])
        viewController.setSubject(subject)
        viewController.setMessageBody(body ?? "", isHTML: false)

        presentingViewController.present(viewController, animated: true, completion: nil)
    }
}

extension MailComposer : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError?) {
        viewController.dismiss(animated: true) {
            self.viewController = nil
        }
    }
}
