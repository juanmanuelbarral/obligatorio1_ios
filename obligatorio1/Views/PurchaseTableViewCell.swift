//
//  PurchaseTableViewCell.swift
//  obligatorio1
//
//  Created by Manu on 25/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

//    OUTLETS
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var seeDetailButton: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// Function that configures the cell with its needed information
    ///
    /// - Parameters:
    ///   - item: item to be reflected on the cell
    func configCell(item: Purchase) {
        // Formatting the date and total price
        dateLabel.text = item.date ?? "Date not found"
        totalPriceLabel.text = "$\(item.total)"
        
        // Formatting the seeDetailButton
        seeDetailButton.layer.cornerRadius = 20
        seeDetailButton.layer.borderColor = UIColor.blue.cgColor
        seeDetailButton.layer.borderWidth = 1
        
        // Formating the cell
        // setting selection style to none so the cell doesn't turn gray or blue when touching it
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
}
