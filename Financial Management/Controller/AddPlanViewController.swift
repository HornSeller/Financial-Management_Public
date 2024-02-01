//
//  AddPlanViewController.swift
//  Financial Management
//
//  Created by Macmini on 23/01/2024.
//

import UIKit

class AddPlanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        myWallets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard !myWallets.isEmpty else {
            return nil
        }
        return myWallets[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !myWallets.isEmpty {
            forWalletTf.text = myWallets[row].name
        } else {
            let alert = UIAlertController(title: "Error", message: "Please add wallet first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    var myWallets: [WalletItem] {
        get {
            return Wallet.shared.wallets
        }
        set {
            Wallet.shared.wallets = newValue
        }
    }
    
    var myPlans: [PlanItem] {
        get {
            return Plan.shared.plans
        }
        set {
            Plan.shared.plans = newValue
        }
    }
    
    let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    @IBOutlet weak var forWalletTf: UITextField!
    @IBOutlet weak var planNameTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 2 - 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        forWalletTf.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTfButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        forWalletTf.inputAccessoryView = toolbar
    }
  
    @objc func doneTfButtonTapped() {
        forWalletTf.resignFirstResponder()
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        planNameTf.resignFirstResponder()
        forWalletTf.resignFirstResponder()
        amountTf.resignFirstResponder()
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if planNameTf.text == "" || forWalletTf.text == "" || amountTf.text == "" {
            let alert = UIAlertController(title: "Error", message: "Textfield must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            return
        }
        
        let containsPlanName = myPlans.contains { item in
            return item.name.lowercased() == planNameTf.text?.lowercased()
        }
        
        if containsPlanName {
            let alert = UIAlertController(title: "Error", message: "Plan name has already existed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
            return
        }
        
        if let text = amountTf.text, let amount = Double(text) {
            // Successfully converted text to a Double
            let newPlan = PlanItem(name: planNameTf.text!, forWallet: forWalletTf.text!, amount: amount, used: 0)
            myPlans.append(newPlan)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("PlanDidAdd"), object: nil)
            }
        } else {
            // Failed to convert text to a Double
            let alert = UIAlertController(title: "Error", message: "Invalid input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            print("Invalid input")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
