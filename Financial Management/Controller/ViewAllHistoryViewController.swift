//
//  ViewAllHistoryViewController.swift
//  Financial Management
//
//  Created by Mac on 28/01/2024.
//

import UIKit

class ViewAllHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewAllHistoryCell", for: indexPath) as! ViewAllHistoryTableViewCell
        cell.transNameLb.text = tableViewData[indexPath.row].title
        if tableViewData[indexPath.row].forPlan != "None" {
            cell.walletNameLb.text = "\(tableViewData[indexPath.row].inWallet)/\(tableViewData[indexPath.row].forPlan)"
        } else {
            cell.walletNameLb.text = tableViewData[indexPath.row].inWallet
        }
        if tableViewData[indexPath.row].type == .income {
            cell.amountLb?.textColor = UIColor(hex: "#22BB7B", alpha: 1)
            cell.amountLb?.text = "+\(numberFormatter.string(for: tableViewData[indexPath.row].amount) ?? "0")"
        } else {
            cell.amountLb?.textColor = UIColor(hex: "#E70866", alpha: 1)
            cell.amountLb?.text = "-\(numberFormatter.string(for: tableViewData[indexPath.row].amount) ?? "0")"
        }
        cell.dateLb.text = dateFormatter.string(from: tableViewData[indexPath.row].date)
        if cell.isSelected {
            cell.iconImageView.image = UIImage(named: "Check")
        } else {
            cell.iconImageView.image = UIImage(named: "Food & Drink")
        }
        if let walletIndex = myWallets.firstIndex(where: { $0.name == tableViewData[indexPath.row].inWallet }) {
            cell.iconImageView.image = UIImage(named: myWallets[walletIndex].icon)
        }
        print(tableViewData[indexPath.row].id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ViewAllHistoryTableViewCell
        cell.iconImageView.image = UIImage(named: "Check")
        transactionsIdToDelete.append(tableViewData[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ViewAllHistoryTableViewCell
        cell.iconImageView.image = UIImage(named: "Food & Drink")
        if let index = transactionsIdToDelete.firstIndex(where: { $0 == tableViewData[indexPath.row].id }) {
            transactionsIdToDelete.remove(at: index)
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
    
    enum Mode {
        case view
        case select
    }
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                selectBarButton.title = "Select"
                deleteBtn.isHidden = true
                selectAllBtn.isHidden = true
                tableView.allowsMultipleSelection = false
                
            case .select:
                selectBarButton.title = "Cancel"
                deleteBtn.isHidden = false
                selectAllBtn.isHidden = false
                tableView.allowsMultipleSelection = true
                
            }
        }
    }
    var numberFormatter = NumberFormatter()
    var dateFormatter = DateFormatter()
    var tableViewData: [TransactionItem] = []
    var selectBarButton: UIBarButtonItem!
    var transactionsIdToDelete: [Int] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var selectAllBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .decimal
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        selectBarButton = {
            let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(menuBarBtnTapped(_:)))
            barButtonItem.tintColor = .white
            return barButtonItem
        }()
        selectBarButton.tintColor = UIColor(hex: "#1E1F22", alpha: 1)
        navigationItem.rightBarButtonItem = selectBarButton
        
        tableViewData = myTransactions.sorted { $0.date > $1.date }

        tableView.register(UINib(nibName: "ViewAllHistoryTableViewCell", bundle: .main), forCellReuseIdentifier: "viewAllHistoryCell")
        tableView.rowHeight = 0.188295 * view.frame.size.width
    }
    
    @objc func menuBarBtnTapped(_ sender: UIButton) {
        mMode = mMode == .view ? .select : .view
        tableView.reloadData()
        print(mMode)
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        print(transactionsIdToDelete)
        if transactionsIdToDelete.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Please choose at least 1 transaction to delete", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Do you really want to delete this transaction(s)?", message: "The amount of this transaction(s) will be added/deducted to their wallet and plan", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
            self.transactionsIdToDelete.sort(by: >)
            for id in self.transactionsIdToDelete {
                if let transIndex = self.myTransactions.firstIndex(where: { transItem in
                    transItem.id == id
                }) {
                    let wallet = self.myTransactions[transIndex].inWallet
                    let plan = self.myTransactions[transIndex].forPlan
                    
                    if self.myTransactions[transIndex].type == .income {
                        if let index = self.myWallets.firstIndex(where: { walletItem in
                            walletItem.name == wallet
                        }) {
                            print(index)
                            self.myWallets[index].amount -= self.myTransactions[transIndex].amount
                        }
                        self.myTransactions.remove(at: transIndex)
                    } else {
                        if let index = self.myWallets.firstIndex(where: { walletItem in
                            walletItem.name == wallet
                        }) {
                            self.myWallets[index].amount += self.myTransactions[transIndex].amount
                            print(index)
                        }
                        if let index = self.myPlans.firstIndex(where: { planItem in
                            planItem.name == plan && planItem.forWallet == wallet
                        }) {
                            self.myPlans[index].used -= self.myTransactions[transIndex].amount
                        }
                        self.myTransactions.remove(at: transIndex)
                    }
                } else {
                    return
                }
            }
            self.tableViewData = self.myTransactions.sorted { $0.date > $1.date }
            self.tableView.reloadData()
            self.transactionsIdToDelete = []
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func selectAllBtnTapped(_ sender: UIButton) {
        
    }
    
    public static func makeSelf() -> ViewAllHistoryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "ViewAllHistoryViewController") as! ViewAllHistoryViewController
        
        return rootViewController
    }
}
