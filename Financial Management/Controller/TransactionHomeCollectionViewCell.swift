//
//  TransactionHomeCollectionViewCell.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import UIKit

class TransactionHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var balanceLb: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 16
    }

}
