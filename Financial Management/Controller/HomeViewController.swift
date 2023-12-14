//
//  HomeViewController.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionHomeCell", for: indexPath) as! TransactionHomeCollectionViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableHomeCell", for: indexPath) as! TransactionHomeTableViewCell
        cell.title?.text = myTransactions[indexPath.row].title
        cell.category?.text = myTransactions[indexPath.row].category
        cell.amount?.text = String(myTransactions[indexPath.row].amount)
        cell.date?.text = dateFormatter.string(from: myTransactions[indexPath.row].date)
        
        return cell
    }
    

    var userDefaults = UserDefaults.standard
    let numberFormatter = NumberFormatter()
    var myTransactions: [TransactionItem] {
        get {
            return Transaction.shared.transactions
        }
        set {
            Transaction.shared.transactions = newValue
        }
    }
        let dateFormatter = DateFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMoneyBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        numberFormatter.numberStyle = .decimal
        
        tableView.register(UINib(nibName: "TransactionHomeTableViewCell", bundle: .main), forCellReuseIdentifier: "tableHomeCell")
        tableView.rowHeight = 0.203562 * view.frame.size.width
        
        collectionView.register(UINib(nibName: "TransactionHomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "collectionHomeCell")
        let layout = UICollectionViewFlowLayout()
        let width = 0.4682 * view.frame.size.width - 2
        let height = 0.24682 * view.frame.size.width - 2
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        if userDefaults.value(forKey: "balance") == nil {
            userDefaults.set(0.0, forKey: "balance")
            userDefaults.synchronize()
        }
        
        if myTransactions.count == 0 {
            myTransactions.append(TransactionItem(title: "Test1", category: "test", amount: 10, date: Date(), type: .expense))
            myTransactions.append(TransactionItem(title: "Test2", category: "test", amount: 20, date: Date(), type: .income))
            myTransactions.append(TransactionItem(title: "Test3", category: "test", amount: 30, date: Date(), type: .expense))
        }

        balanceLabel.text = numberFormatter.string(from: self.userDefaults.value(forKey: "balance") as! NSNumber)
        print(userDefaults.value(forKey: "balance"))
    }

    @IBAction func addMoneyBtnTapped(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Enter the transaction", message: nil, preferredStyle: .alert)
//        alert.addTextField() { (textfield) in
//            textfield.placeholder = "Enter amount here"
//            textfield.keyboardType = .numberPad
//        }
//        
//        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0]
//            var currentAmount = self.userDefaults.value(forKey: "balance") as! Double
//            print(currentAmount)
//            if let text = textField?.text, let doubleValue = Double(text) {
//                currentAmount += doubleValue
//            }
//            print(currentAmount)
//            self.userDefaults.set(currentAmount, forKey: "balance")
//            
//            self.balanceLabel.text = self.numberFormatter.string(from: self.userDefaults.value(forKey: "balance") as! NSNumber)
//        }))
//        
//        present(alert, animated: true)
        self.performSegue(withIdentifier: "addTransactionSegue", sender: self)
    }
    
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        print(myTransactions)
    }
    
}
