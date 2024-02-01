//
//  AddWalletViewController.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import UIKit

class AddWalletViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        myIcons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myIcons[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        iconTf.text = myIcons[row]
    }
    
    var myWallets: [WalletItem] {
        get {
            return Wallet.shared.wallets
        }
        set {
            Wallet.shared.wallets = newValue
        }
    }
    
    let pickerView = UIPickerView()
    let myIcons: [String] = ["Food & Drink", "Shopping", "Housing", "Transportation", "Vehicle", "Life Style", "Geek", "Other"]
    
    @IBOutlet weak var walletNameTf: UITextField!
    @IBOutlet weak var iconTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        iconTf.inputView = pickerView

        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 3
        
        amountTf.keyboardType = .numberPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTfButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        iconTf.inputAccessoryView = toolbar
    }
    
    @objc func doneTfButtonTapped() {
        iconTf.resignFirstResponder()
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if walletNameTf.text == "" || iconTf.text == "" || amountTf.text == "" {
            let alert = UIAlertController(title: "Error", message: "Textfield must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            return
        }
        
        let containsWalletName = myWallets.contains { item in
            return item.name.lowercased() == walletNameTf.text?.lowercased()
        }
        
        if containsWalletName {
            let alert = UIAlertController(title: "Error", message: "Wallet name has already existed", preferredStyle: .alert)
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
