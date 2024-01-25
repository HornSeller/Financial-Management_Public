//
//  AddWalletViewController.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import UIKit

class AddWalletViewController: UIViewController, UITextFieldDelegate {
    
    var myWallets: [WalletItem] {
        get {
            return Wallet.shared.wallets
        }
        set {
            Wallet.shared.wallets = newValue
        }
    }
    
    @IBOutlet weak var walletNameTf: UITextField!
    @IBOutlet weak var iconTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 3
        
        amountTf.keyboardType = .numberPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if walletNameTf.text == "" || iconTf.text == "" || amountTf.text == "" {
            let alert = UIAlertController(title: "Error", message: "Textfield must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            return
        }
        
        if let text = amountTf.text, let amount = Double(text) {
            // Successfully converted text to a Double
            let newWallet = WalletItem(name: walletNameTf.text!, icon: iconTf.text!, amount: amount)
            myWallets.append(newWallet)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("WalletDidAdd"), object: nil)
            }
        } else {
            // Failed to convert text to a Double
            let alert = UIAlertController(title: "Error", message: "Invalid input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            print("Invalid input")
        }
        
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        walletNameTf.resignFirstResponder()
        iconTf.resignFirstResponder()
        amountTf.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
