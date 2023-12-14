//
//  AddTransactionViewController.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class AddTransactionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var categoryTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.maximumDate = Date()
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 3
        
        amountTf.keyboardType = .numberPad
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        titleTf.resignFirstResponder()
        categoryTf.resignFirstResponder()
        amountTf.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        print(amountTf.text ?? "!")
        print(dateFormatter.string(from: datePicker.date))
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        switch selectedSegmentIndex {
        case 0:
            print("0")
            titleTf.text = ""
            categoryTf.text = ""
            amountTf.text = ""
        case 1:
            print("1")
            titleTf.text = ""
            categoryTf.text = ""
            amountTf.text = ""
        default:
            break
        }
    }
}
