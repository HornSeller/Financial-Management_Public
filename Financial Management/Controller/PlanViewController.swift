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
        
        numberformatter.numberStyle = .decimal
        
        NotificationCenter.default.addObserver(self, selector: #selector(planDidAddNotification), name: Notification.Name("PlanDidAdd"), object: nil)

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
    
    @objc func planDidAddNotification() {
        collectionView.reloadData()
    }
    
}
