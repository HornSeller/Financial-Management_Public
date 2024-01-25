//
//  HomeViewController.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myWallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionHomeCell", for: indexPath) as! TransactionHomeCollectionViewCell
        cell.titleLb.text = myWallets[indexPath.row].name
        cell.balanceLb.text = numberFormatter.string(for: myWallets[indexPath.row].amount)
        cell.moreBtn.showsMenuAsPrimaryAction = true
        cell.moreBtn.menu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Delete", handler: { (_) in
                
            }),
            
            UIAction(title: "Edit", handler: { (_) in
                
            })
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableHomeCell", for: indexPath) as! TransactionHomeTableViewCell
        cell.title?.text = myTransactions[indexPath.row].title
        cell.wallet?.text = myTransactions[indexPath.row].inWallet
        cell.amount?.text = numberFormatter.string(for: myTransactions[indexPath.row].amount)
        cell.date?.text = dateFormatter.string(from: myTransactions[indexPath.row].date)
        if myTransactions[indexPath.row].type == .income {
            cell.amount?.textColor = UIColor(hex: "#22BB7B", alpha: 1)
        } else {
            cell.amount?.textColor = UIColor(hex: "#E70866", alpha: 1)
        }
        
        return cell
    }
    
    let dateFormatter = DateFormatter()
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
    var myWallets: [WalletItem] {
        get {
            return Wallet.shared.wallets
        }
        set {
            Wallet.shared.wallets = newValue
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTransactionBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTransactionBtn.layer.cornerRadius = addTransactionBtn.frame.size.height / 2 - 1
        numberFormatter.numberStyle = .decimal
        tableView.reloadData()
        collectionView.reloadData()
        
        updateBalance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletDidAddNotification), name: Notification.Name("WalletDidAdd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transactionDidAddNotification), name: Notification.Name("TransactionDidAdd"), object: nil)
        print(myWallets)
        dateFormatter.dateFormat = "dd MMM yyyy"
                
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

    }
    
    @objc func walletDidAddNotification() {
        // Reload UICollectionView khi nhận được thông báo "WalletDidAdd"
        collectionView.reloadData()
        updateBalance()
    }
    
    @objc func transactionDidAddNotification() {
        tableView.reloadData()
        collectionView.reloadData()
        updateBalance()
    }
        
    @IBAction func addWalletBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addWalletSegue", sender: self)
    }
    
    @IBAction func addTransactionBtnTapped(_ sender: UIButton) {
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
    
    func updateBalance() {
        var balance: Double = 0
        for wallet in myWallets {
            balance += wallet.amount
        }
        balanceLabel.text = numberFormatter.string(for: balance)
    }
}
