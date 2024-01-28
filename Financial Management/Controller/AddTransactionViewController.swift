//
//  AddTransactionViewController.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class AddTransactionViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return myWallets.count
        } else {
            var plans: [String] = []
            for plan in myPlans {
                if plan.forWallet.elementsEqual(walletTf.text!) {
                    plans.append(plan.forWallet)
                }
            }
            return plans.count + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return myWallets[row].name
        } else {
            var plans: [String] = ["None"]
            for plan in myPlans {
                if plan.forWallet.elementsEqual(walletTf.text!) {
                    plans.append(plan.name)
                }
            }
            return plans[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            walletTf.text = myWallets[row].name
        } else {
            var plans: [String] = ["None"]
            for plan in myPlans {
                if plan.forWallet == walletTf.text! {
                    plans.append(plan.name)
                }
            }
            planTf.text = plans[row]
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
    
    var myTransactions: [TransactionItem] {
        get {
            return Transaction.shared.transactions
        }
        set {
            Transaction.shared.transactions = newValue
        }
    }
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var transactionTf: UITextField!
    @IBOutlet weak var walletTf: UITextField!
    @IBOutlet weak var planTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var planLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.dataSource = self
        pickerView1.delegate = self

        pickerView2.dataSource = self
        pickerView2.delegate = self
        
        walletTf.inputView = pickerView1
        planTf.inputView = pickerView2

        datePicker.maximumDate = Date()
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 3
        
        amountTf.keyboardType = .numberPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTfButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        walletTf.inputAccessoryView = toolbar
        planTf.inputAccessoryView = toolbar
    }
    
    @objc func doneTfButtonTapped() {
        walletTf.resignFirstResponder()
        planTf.resignFirstResponder()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        transactionTf.resignFirstResponder()
        walletTf.resignFirstResponder()
        amountTf.resignFirstResponder()
        planTf.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if transactionTf.text == "" || amountTf.text == "" || walletTf.text == "" {
                let alert = UIAlertController(title: "Error", message: "Textfield must not be empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            
            if let text = amountTf.text, let amount = Double(text) {
                let newTransaction = TransactionItem(title: transactionTf.text!, id: UserDefaults.standard.integer(forKey: "transactionId"),inWallet: walletTf.text!, forPlan: "None", amount: amount, date: datePicker.date, type: .income)
                myTransactions.append(newTransaction)
                UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey: "transactionId") + 1, forKey: "transactionId")
                for i in 0 ..< myWallets.count {
                    if myWallets[i].name == walletTf.text {
                        myWallets[i].amount += amount
                        break
                    }
                }
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: Notification.Name("TransactionDidAdd"), object: nil)
                }
            } else {
                // Failed to convert text to a Double
                let alert = UIAlertController(title: "Error", message: "Invalid input", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                print("Invalid input")
            }
        } else {
            if transactionTf.text == "" || amountTf.text == "" || walletTf.text == "" || planTf.text == "" {
                let alert = UIAlertController(title: "Error", message: "Textfield must not be empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            
            if let text = amountTf.text, let amount = Double(text) {
                for i in 0 ..< myWallets.count {
                    if myWallets[i].name == walletTf.text {
                        if amount > myWallets[i].amount {
                            let alert = UIAlertController(title: "Error", message: "Wallet balance is not enough", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                            print("Invalid input")
                            return
                        }
                        myWallets[i].amount -= amount
                        break
                    }
                }
                
                if planTf.text != "None" {
                    for i in 0 ..< myPlans.count {
                        if myPlans[i].name == planTf.text && myPlans[i].forWallet == walletTf.text  {
                            myPlans[i].used += amount
                            break
                        }
                    }
                }
                
                let newTransaction = TransactionItem(title: transactionTf.text!, id: UserDefaults.standard.integer(forKey: "transactionId"), inWallet: walletTf.text!, forPlan: planTf.text!, amount: amount, date: datePicker.date, type: .expense)
                myTransactions.append(newTransaction)
                UserDefaults.standard.setValue(UserDefaults.standard.integer(forKey: "transactionId") + 1, forKey: "transactionId")
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: Notification.Name("TransactionDidAdd"), object: nil)
                }
            } else {
                // Failed to convert text to a Double
                let alert = UIAlertController(title: "Error", message: "Invalid input", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                print("Invalid input")
            }

        }
        
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        switch selectedSegmentIndex {
        case 0:
            print("0")
            transactionTf.text = ""
            walletTf.text = ""
            amountTf.text = ""
            planTf.text = ""
            planTf.isHidden = true
            planLb.isHidden = true
        case 1:
            print("1")
            transactionTf.text = ""
            walletTf.text = ""
            amountTf.text = ""
            planTf.text = ""
            planTf.isHidden = false
            planLb.isHidden = false
        default:
            break
        }
    }
    
    func walletBalance() -> Double {
        var balance: Double = 0
        for wallet in myWallets {
            balance += wallet.amount
        }
        return balance
    }
}
