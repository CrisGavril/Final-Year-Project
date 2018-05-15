//
//  ContactUsViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {
    @IBAction func call() {
        guard let url = URL(string: "tel://+441122334455") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet var mailButton: UIButton!
    
    @IBAction func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
                return
        }
        let mailComposer = MFMailComposeViewController()
        let recipientEmail = "cris.gavril@gmail.com"
        mailComposer.setToRecipients([recipientEmail])
        mailComposer.mailComposeDelegate = self
        self.present(mailComposer, animated: true, completion: nil)
    }
    
    @IBAction func viewOnMap() {
        guard let url = URL(string: "http://maps.apple.com/?q=64+Lansdowne+Way+sw82dr+London+UK") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mailButton.isEnabled = MFMailComposeViewController.canSendMail()
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true) {
            if result == .sent {
                let alert = UIAlertController(title: "Thank you for your email", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
