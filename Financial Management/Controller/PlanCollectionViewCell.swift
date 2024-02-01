//
//  PlanCollectionViewCell.swift
//  Financial Management
//
//  Created by Macmini on 23/01/2024.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var planNameLb: UILabel!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var spendLb: UILabel!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var percentLb: UILabel!
    
    let trackView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subview.layer.cornerRadius = 16
        baseView.layer.cornerRadius = 6
        trackView.layer.cornerRadius = 6
    }

}
