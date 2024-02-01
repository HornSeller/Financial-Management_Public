//
//  AnalyticsViewController.swift
//  Financial Management
//
//  Created by Macmini on 01/02/2024.
//

import UIKit

class AnalyticsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "analyticsCell", for: indexPath) as! AnalyticsCollectionViewCell
        cell.walletNameLb.text = dataCollectionView[indexPath.row].walletName
        cell.usedAmountLb.text = numberFormatter.string(for: dataCollectionView[indexPath.row].usedAmount)
        cell.iconImgView.image = UIImage(named: dataCollectionView[indexPath.row].icon)

        return cell
    }
    
    struct WalletUsedAmount: Codable {
        var walletName: String
        var icon: String
        var usedAmount: Double
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
    
    let view1 = UIView()
    let view2 = UIView()
    var dataCollectionView: [WalletUsedAmount] = []
    let numberFormatter = NumberFormatter()

    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datepicker1: UIDatePicker!
    @IBOutlet weak var datepicker2: UIDatePicker!
    @IBOutlet weak var incomePercentView: UIView!
    @IBOutlet weak var expensePercentView: UIView!
    @IBOutlet weak var incomeBaseView: UIView!
    @IBOutlet weak var expenseBaseView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var incomeAmountLB: UILabel!
    @IBOutlet weak var expenseAmountLB: UILabel!
    @IBOutlet weak var incomePercentLb: UILabel!
    @IBOutlet weak var expensePercentLb: UILabel!
    @IBOutlet weak var spendingAmountLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        
        incomePercentView.layer.cornerRadius = 4
        expensePercentView.layer.cornerRadius = 4
        incomeBaseView.layer.cornerRadius = 6
        expenseBaseView.layer.cornerRadius = 6
        subView1.layer.cornerRadius = 16
        subView2.layer.cornerRadius = 16
        calendarView.layer.cornerRadius = 10
        
        datepicker1.date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        datepicker2.date = Date()
        
        datepicker1.maximumDate = datepicker2.date
        datepicker2.minimumDate = datepicker1.date
        datepicker2.maximumDate = Date()
        
        datepicker1.addTarget(self, action: #selector(datePicker1ValueChanged), for: .valueChanged)
        datepicker2.addTarget(self, action: #selector(datePicker2ValueChanged), for: .valueChanged)
        
        collectionView.register(UINib(nibName: "AnalyticsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "analyticsCell")
        let layout = UICollectionViewFlowLayout()
        let width = (subView1.frame.width - 20) / 2 - 2
        let height = 0.25212 * subView1.frame.width
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        let calendar = Calendar.current
        let startOfDayDatePicker1 = calendar.startOfDay(for: datepicker1.date)
        let endOfDayDatePicker2 = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: datepicker2.date)!
        
        loadDataCollectionView(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2) { dataCollectionView in
            self.dataCollectionView = dataCollectionView
            self.collectionView.reloadData()
        }
        
        loadCashFlow(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let calendar = Calendar.current
        let startOfDayDatePicker1 = calendar.startOfDay(for: datepicker1.date)
        let endOfDayDatePicker2 = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: datepicker2.date)!
        
        loadDataCollectionView(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2) { dataCollectionView in
            self.dataCollectionView = dataCollectionView
            self.collectionView.reloadData()
        }
        
        view1.removeFromSuperview()
        view2.removeFromSuperview()
        loadCashFlow(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2)
    }
    
    @objc func datePicker1ValueChanged() {
        let selectedDate = datepicker1.date
        datepicker2.minimumDate = selectedDate
        let calendar = Calendar.current
        let startOfDayDatePicker1 = calendar.startOfDay(for: selectedDate)
        let endOfDayDatePicker2 = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: datepicker2.date)!
        print("selec \(selectedDate)")
        loadDataCollectionView(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2) { dataCollectionView in
            self.dataCollectionView = dataCollectionView
            self.collectionView.reloadData()
        }
        
        view1.removeFromSuperview()
        view2.removeFromSuperview()
        loadCashFlow(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2)
    }
    
    @objc func datePicker2ValueChanged() {
        let selectedDate = datepicker2.date
        datepicker1.maximumDate = selectedDate
        let calendar = Calendar.current
        let startOfDayDatePicker1 = calendar.startOfDay(for: datepicker1.date)
        let endOfDayDatePicker2 = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!
        print("selec \(selectedDate)")
        loadDataCollectionView(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2) { dataCollectionView in
            self.dataCollectionView = dataCollectionView
            self.collectionView.reloadData()
        }
        
        view1.removeFromSuperview()
        view2.removeFromSuperview()
        loadCashFlow(startDate: startOfDayDatePicker1, endDate: endOfDayDatePicker2)
    }
    
    func loadDataCollectionView(startDate: Date, endDate: Date, completion: @escaping([WalletUsedAmount]) -> Void) {
        var data: [WalletUsedAmount] = []
        for wallet in myWallets {
            var usedAmount: Double = 0
            for transaction in myTransactions {
                if transaction.inWallet == wallet.name && transaction.date >= startDate - 1 && transaction.date <= endDate && transaction.type == .expense {
                    usedAmount += transaction.amount
                }
            }
            data.append(WalletUsedAmount(walletName: wallet.name, icon: wallet.icon, usedAmount: usedAmount))
            if wallet.name == myWallets.last?.name {
                completion(data)
            }
        }
    }
    
    func loadCashFlow(startDate: Date, endDate: Date) {
        var expenseAmount: Double = 0
        var incomeAmount: Double = 0
        incomePercentLb.text = "0%"
        expensePercentLb.text = "0%"
        incomeAmountLB.text = "0"
        expenseAmountLB.text = "0"
        spendingAmountLb.text = "0"
        for transaction in myTransactions {
            if transaction.date >= startDate - 1 && transaction.date <= endDate && transaction.type == .expense {
                expenseAmount += transaction.amount
            } else if transaction.date >= startDate - 1 && transaction.date <= endDate && transaction.type == .income {
                incomeAmount += transaction.amount
            }
            
            if transaction.id == myTransactions.last?.id {
                if incomeAmount > expenseAmount {
                    view1.frame = CGRect(x: 0, y: 0, width: incomeBaseView.frame.width, height: incomeBaseView.frame.height)
                    view1.backgroundColor = UIColor(hex: "#22BB7B", alpha: 1)
                    view1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view1.layer.cornerRadius = 6
                    incomeBaseView.addSubview(view1)
                    
                    view2.frame = CGRect(x: 0, y: 0, width: (expenseAmount / incomeAmount) * expenseBaseView.frame.width, height: expenseBaseView.frame.height)
                    view2.backgroundColor = UIColor(hex: "#E70866", alpha: 1)
                    view2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view2.layer.cornerRadius = 6
                    expenseBaseView.addSubview(view2)
                    
                    incomePercentLb.text = "100%"
                    expensePercentLb.text = "\(Int((expenseAmount / incomeAmount) * 100))%"
                } else if incomeAmount < expenseAmount {
                    view1.frame = CGRect(x: 0, y: 0, width: (incomeAmount / expenseAmount) * incomeBaseView.frame.width, height: incomeBaseView.frame.height)
                    view1.backgroundColor = UIColor(hex: "#22BB7B", alpha: 1)
                    view1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view1.layer.cornerRadius = 6
                    incomeBaseView.addSubview(view1)
                    
                    view2.frame = CGRect(x: 0, y: 0, width: expenseBaseView.frame.width, height: expenseBaseView.frame.height)
                    view2.backgroundColor = UIColor(hex: "#E70866", alpha: 1)
                    view2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view2.layer.cornerRadius = 6
                    expenseBaseView.addSubview(view2)
                    
                    incomePercentLb.text = "\(Int((incomeAmount / expenseAmount) * 100))%"
                    expensePercentLb.text = "100%"
                } else {
                    if incomeAmount == 0 {
                        view1.frame = CGRect(x: 0, y: 0, width: 0, height: incomeBaseView.frame.height)
                        incomePercentLb.text = "0%"
                    } else {
                        view1.frame = CGRect(x: 0, y: 0, width: incomeBaseView.frame.width, height: incomeBaseView.frame.height)
                        incomePercentLb.text = "100%"
                    }
                    view1.backgroundColor = UIColor(hex: "#22BB7B", alpha: 1)
                    view1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view1.layer.cornerRadius = 6
                    incomeBaseView.addSubview(view1)
                    
                    if expenseAmount == 0 {
                        view2.frame = CGRect(x: 0, y: 0, width: 0, height: expenseBaseView.frame.height)
                        expensePercentLb.text = "0%"
                    } else {
                        view2.frame = CGRect(x: 0, y: 0, width: expenseBaseView.frame.width, height: expenseBaseView.frame.height)
                        expensePercentLb.text = "100%"
                    }
                    view2.backgroundColor = UIColor(hex: "#E70866", alpha: 1)
                    view2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view2.layer.cornerRadius = 6
                    expenseBaseView.addSubview(view2)
                }
                
                incomeAmountLB.text = "\(numberFormatter.string(for: Int(incomeAmount)) ?? "0")"
                expenseAmountLB.text = "\(numberFormatter.string(for: Int(expenseAmount)) ?? "0")"
                spendingAmountLb.text = "\(numberFormatter.string(for: Int(expenseAmount)) ?? "0")"
            }
        }
    }
}
