//
//  PlanCollectionViewCell.swift
//  Financial Management
//
//  Created by Macmini on 23/01/2024.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var planNameLb: UILabel!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var spendLb: UILabel!
    @IBOutlet weak var subview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subview.layer.cornerRadius = 16
    }

}
