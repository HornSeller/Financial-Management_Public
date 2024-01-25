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
        cell.progressView.progress = Float(myPlans[indexPath.row].used / myPlans[indexPath.row].amount)
        if myPlans[indexPath.row].used / myPlans[indexPath.row].amount > 1 {
            cell.progressView.progressTintColor = .red
        }
        
        return cell
    }
    
    var myPlans: [PlanItem] {
        get {
            return Plan.shared.plans
        }
        set {
            Plan.shared.plans = newValue
        }
    }

    let numberformatter = NumberFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
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
    }
    
    @IBAction func addPlanBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "planSegue", sender: self)
    }
    
    @objc func transactionDidAddNotification() {
        collectionView.reloadData()
    }
    
    @objc func planDidAddNotification() {
        collectionView.reloadData()
    }
    
}
