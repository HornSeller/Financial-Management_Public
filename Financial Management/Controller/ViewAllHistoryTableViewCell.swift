//
//  ViewAllHistoryTableViewCell.swift
//  Financial Management
//
//  Created by Mac on 28/01/2024.
//

import UIKit

class ViewAllHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var transNameLb: UILabel!
    @IBOutlet weak var walletNameLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
