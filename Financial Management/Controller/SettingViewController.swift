//
//  SettingViewController.swift
//  Financial Management
//
//  Created by Macmini on 30/01/2024.
//

import UIKit
import StoreKit
import MessageUI
import PasscodeKit

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var rateusBtn: UIButton!
    @IBOutlet weak var shareappBtn: UIButton!
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedbackBtn.layer.cornerRadius = 16
        rateusBtn.layer.cornerRadius = 16
        shareappBtn.layer.cornerRadius = 16
        
        if PasscodeKit.enabled() {
            switchBtn.isOn = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PasscodeKit.enabled() {
            switchBtn.isOn = true
        } else {
            switchBtn.isOn = false
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

        switch result {
        case .cancelled:
            // Xử lý khi người dùng hủy gửi email
            break
        case .saved:
            // Xử lý khi email được lưu như phiên bản nháp
            break
        case .sent:
            // Xử lý khi email được gửi thành công
            break
        case .failed:
            // Xử lý khi gửi email thất bại
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if switchBtn.isOn {
            PasscodeKit.createPasscode(self)
        } else {
            PasscodeKit.removePasscode(self)
        }
    }
    
    @IBAction func changePasscodeBtnTapped(_ sender: UIButton) {
        if !PasscodeKit.enabled() {
            let alert = UIAlertController(title: "PassCode does not exist", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        else {
            PasscodeKit.changePasscode(self)
        }
    }
    
    @IBAction func feedbackBtnTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["duc.nm207592@sis.hust.edu.vn"])
            composeVC.setSubject("Feedback your app!")
            composeVC.setMessageBody("Dear Duc Nguyen, \n\n", isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func rateBtnTapped(_ sender: UIButton) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        if let name = URL(string: "https://apps.apple.com/us/app/ai-cleaner/id6475330781"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
            let alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}
