//
//  TransactionHomeTableViewCell.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import UIKit

class TransactionHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var wallet: UILabel?
    @IBOutlet weak var amount: UILabel?
    @IBOutlet weak var date: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
