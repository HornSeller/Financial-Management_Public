//
//  HomeViewController.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionHomeCell", for: indexPath) as! TransactionHomeCollectionViewCell
        cell.titleLb.text = collectionViewData[indexPath.row].name
        cell.balanceLb.text = numberFormatter.string(for: collectionViewData[indexPath.row].amount)
        cell.iconImgView.image = UIImage(named: collectionViewData[indexPath.row].icon)
        cell.moreBtn.showsMenuAsPrimaryAction = true
        cell.moreBtn.menu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Delete", handler: { (_) in
                let alert = UIAlertController(title: "Do you really want to delete this wallet?", message: "All Transactions and Plans of this Wallet will be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                    self.myTransactions.removeAll { $0.inWallet == self.collectionViewData[indexPath.row].name }
                    self.myPlans.removeAll { $0.forWallet == self.collectionViewData[indexPath.row].name }
                    self.myWallets.removeAll { $0.name == self.collectionViewData[indexPath.row].name }
                    self.collectionViewData = self.myWallets.reversed()
                    self.collectionView.reloadData()
                    self.tableViewData = self.myTransactions.reversed()
                    self.tableView.reloadData()
                    self.updateBalance()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }),
            
            UIAction(title: "Edit", handler: { (_) in
                
            })
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableHomeCell", for: indexPath) as! TransactionHomeTableViewCell
        cell.title?.text = tableViewData[indexPath.row].title
        if tableViewData[indexPath.row].forPlan != "None" {
            cell.wallet?.text = "\(tableViewData[indexPath.row].inWallet)/\(tableViewData[indexPath.row].forPlan)"
        } else {
            cell.wallet?.text = tableViewData[indexPath.row].inWallet
        }
        if tableViewData[indexPath.row].type == .income {
            cell.amount?.textColor = UIColor(hex: "#22BB7B", alpha: 1)
            cell.amount?.text = "+\(numberFormatter.string(for: tableViewData[indexPath.row].amount) ?? "0")"
        } else {
            cell.amount?.textColor = UIColor(hex: "#E70866", alpha: 1)
            cell.amount?.text = "-\(numberFormatter.string(for: tableViewData[indexPath.row].amount) ?? "0")"
        }
        cell.date?.text = dateFormatter.string(from: tableViewData[indexPath.row].date)
        if let walletIndex = myWallets.firstIndex(where: { $0.name == tableViewData[indexPath.row].inWallet }) {
            cell.iconImgView.image = UIImage(named: myWallets[walletIndex].icon)
        }
        
        return cell
    }
    
    let dateFormatter = DateFormatter()
    var userDefaults = UserDefaults.standard
    let numberFormatter = NumberFormatter()
    var tableViewData: [TransactionItem] = []
    var collectionViewData: [WalletItem] = []
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
    var myPlans: [PlanItem] {
        get {
            return Plan.shared.plans
        }
        set {
            Plan.shared.plans = newValue
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTransactionBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: ["transactionId": 0])
        
        addTransactionBtn.layer.cornerRadius = addTransactionBtn.frame.size.height / 2 - 1
        numberFormatter.numberStyle = .decimal
        tableView.reloadData()
        collectionView.reloadData()
        tableViewData = myTransactions.reversed()
        collectionViewData = myWallets.reversed()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewData = myTransactions.reversed()
        collectionViewData = myWallets.reversed()
        tableView.reloadData()
        collectionView.reloadData()
        updateBalance()
    }
    
    @objc func walletDidAddNotification() {
        // Reload UICollectionView khi nhận được thông báo "WalletDidAdd"
        collectionViewData = myWallets.reversed()
        collectionView.reloadData()
        updateBalance()
    }
    
    @objc func transactionDidAddNotification() {
        tableViewData = myTransactions.reversed()
        collectionViewData = myWallets.reversed()
        tableView.reloadData()
        collectionView.reloadData()
        updateBalance()
    }
        
    @IBAction func addWalletBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addWalletSegue", sender: self)
    }
    
    @IBAction func addTransactionBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addTransactionSegue", sender: self)
    }
    
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(ViewAllHistoryViewController.makeSelf(), animated: true)
    }
    
    func updateBalance() {
        var balance: Double = 0
        for wallet in myWallets {
            balance += wallet.amount
        }
        balanceLabel.text = numberFormatter.string(for: balance)
    }
}
