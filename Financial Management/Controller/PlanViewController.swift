//
//  PlanViewController.swift
//  Financial Management
//
//  Created by Macmini on 23/01/2024.
//

import UIKit

class PlanViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planCell", for: indexPath) as! PlanCollectionViewCell
        cell.planNameLb.text = myPlans[indexPath.row].name
        cell.walletNameLb.text = myPlans[indexPath.row].forWallet
        cell.totalLb.text = numberformatter.string(for: myPlans[indexPath.row].amount)
        cell.spendLb.text = numberformatter.string(for: myPlans[indexPath.row].used)
        let progress = myPlans[indexPath.row].used / myPlans[indexPath.row].amount
        cell.trackView.removeFromSuperview()
        cell.trackView.frame = CGRect(x: 0, y: 0, width: progress * cell.baseView.frame.width, height: cell.baseView.frame.height)
        cell.baseView.addSubview(cell.trackView)
        if progress <= 0.3 {
            cell.trackView.backgroundColor = UIColor(hex: "#22BB7B", alpha: 1)
            cell.percentLb.textColor = UIColor(hex: "#22BB7B", alpha: 1)
        } else if progress > 0.3 && progress <= 0.8 {
            cell.trackView.backgroundColor = UIColor(hex: "#366AF0", alpha: 1)
            cell.percentLb.textColor = UIColor(hex: "#366AF0", alpha: 1)
        } else {
            cell.trackView.backgroundColor = UIColor(hex: "#E70866", alpha: 1)
            cell.percentLb.textColor = UIColor(hex: "#E70866", alpha: 1)
        }
        if let walletIndex = myWallets.firstIndex(where: { $0.name == myPlans[indexPath.row].forWallet }) {
            cell.iconImageView.image = UIImage(named: myWallets[walletIndex].icon)
        }
        cell.percentLb.text = "\(Int(progress * 100))%"
        cell.moreBtn.showsMenuAsPrimaryAction = true
        cell.moreBtn.menu = UIMenu(options: .displayInline, children: [
            UIAction(title: "Delete", handler: { (_) in
                let alert = UIAlertController(title: "Do you really want to delete this plan?", message: "All Transactions of this Plan will be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                    let wallet = self.myPlans[indexPath.row].forWallet
                    for transaction in self.myTransactions {
                        if transaction.inWallet == wallet && transaction.forPlan == self.myPlans[indexPath.row].name {
                            if let walletIndex = self.myWallets.firstIndex(where: { walletItem in
                                walletItem.name == wallet
                            }) {
                                if transaction.type == .income {
                                    self.myWallets[walletIndex].amount -= transaction.amount
                                } else {
                                    self.myWallets[walletIndex].amount += transaction.amount
                                }
                            }
                            self.myTransactions.removeAll(where: { $0.id == transaction.id })
                        }
                    }
                    self.myPlans.remove(at: indexPath.row)
                    if self.myPlans.count == 0 {
                        self.backgroundImageView.isHidden = false
                    }
                    collectionView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }),
            
            UIAction(title: "Rename", handler: { (_) in
                let alert = UIAlertController(title: "Enter the new name", message: nil, preferredStyle: .alert)
                alert.addTextField()
                alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    if textField?.text == "" {
                        let alert = UIAlertController(title: "Error", message: "Please enter plan name", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alert, animated: true)
                        return
                    }
                    
                    if let planIndex = self.myPlans.firstIndex(where: { $0.name == cell.planNameLb.text }) {
                        self.myPlans[planIndex].name = (textField?.text)!
                    }
                    
                    for i in 0 ..< self.myTransactions.count {
                        if self.myTransactions[i].forPlan == cell.planNameLb.text {
                            self.myTransactions[i].forPlan = (textField?.text)!
                        }
                    }
                    
                    self.collectionView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            })
        ])
        
        return cell
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

    let numberformatter = NumberFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myPlans)
        numberformatter.numberStyle = .decimal
        
        NotificationCenter.default.addObserver(self, selector: #selector(planDidAddNotification), name: Notification.Name("PlanDidAdd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transactionDidAddNotification), name: Notification.Name("TransactionDidAdd"), object: nil)

        collectionView.register(UINib(nibName: "PlanCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "planCell")
        
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.size.width
        let height = 0.5089 * view.frame.size.width - 2
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        if myPlans.count > 0 {
            backgroundImageView.isHidden = true
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    @IBAction func addPlanBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "planSegue", sender: self)
    }
    
    @objc func transactionDidAddNotification() {
        collectionView.reloadData()
    }
    
    @objc func planDidAddNotification() {
        collectionView.reloadData()
        backgroundImageView.isHidden = true
    }
    
}
