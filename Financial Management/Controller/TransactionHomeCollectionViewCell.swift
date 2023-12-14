//
//  TransactionHomeCollectionViewCell.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import UIKit

class TransactionHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 16
    }

}
