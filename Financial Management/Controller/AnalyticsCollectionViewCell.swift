//
//  AnalyticsCollectionViewCell.swift
//  Financial Management
//
//  Created by Macmini on 01/02/2024.
//

import UIKit

class AnalyticsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var usedAmountLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subView.layer.cornerRadius = 18
    }

}
