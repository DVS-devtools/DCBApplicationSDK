//
//  ViewController.swift
//  DCBExternalApplication
//
//  Created by Pierre Jonny Cau on 12/03/2020.
//  Copyright © 2020 Buongiorno. All rights reserved.
//

import DCBApiExt
import UIKit

class ViewController: UIViewController {
    @IBOutlet var logTextView: UITextView!
    @IBOutlet var resetButtonItem: UIBarButtonItem!

    @IBAction func resetAction(_: Any) {
        reset()
        logTextView.text = nil
        logTextView.insertText("DCB Account Reset\n")
    }

    internal var dcbCompletion: DCBUserManagerCheckCompletion?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogging()

        guard let dcbCompletion = dcbCompletion else {
            print("the callback is nil. Please, assign it")
            return
        }

        DCBUserManager(client: Credential.dcbClient, loggingIsEnabled: Credential.logging).checkFlowDCB(isActive: false, completion: dcbCompletion)
    }
}

extension Notification.Name {
    static let dcbLogging = Notification.Name(rawValue: "DCBAPI_LOGGING")
}

extension ViewController {
    private func reset() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        NSUbiquitousKeyValueStore.default.dictionaryRepresentation.forEach { key, value in
            print("NSUbiquitousKeyValueStore -> key is :\(key) and value is \(value)")
            NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
        }
    }

    func setupLogging() {
        NotificationCenter.default.addObserver(self, selector: #selector(loggingData(_:)), name: .dcbLogging, object: nil)

        logTextView.insertText("DCB FLOW\n")

        dcbCompletion = { date, _ in

            if let _ = DCBUserManager.dcbUser {
                self.logTextView.insertText("\n● User Digital Virgo \n")

                if let date = date {
                    self.logTextView.insertText("\n● DCB FLOW FINISHED WITH EXPIRATION TIME WITH DATE: \(date) \n")
                } else {
                    self.logTextView.insertText("\n● User expired, not subscribed. User must pay again to access the product \n")
                }
            } else {
                self.logTextView.insertText("\n● Normal user discover the app from AppStore \n")
            }
        }
    }

    @objc func loggingData(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let message = userInfo["message"] as? String
        else { return }

        DispatchQueue.main.async {
            self.logTextView.insertText(message)
        }
    }
}
