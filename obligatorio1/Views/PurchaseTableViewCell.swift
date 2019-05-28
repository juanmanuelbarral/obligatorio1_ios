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
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var dateHourLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
//    PROPERTIES
    var _purchase: Purchase?
    
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
        self._purchase = item
        
        // Formatting the date and total price
        dateDayLabel.text = item.dateDayToString(dayFormat: .medium) ?? "Date not found"
        dateHourLabel.text = item.dateTimeToString(timeFormat: .short) ?? ""
        totalPriceLabel.text = "$\(item.total)"
        
        // Formatting the seeDetailButton
        detailButton.layer.cornerRadius = 20
        detailButton.layer.borderColor = UIColor.blue.cgColor
        detailButton.layer.borderWidth = 1
        
        // Formating the cell
        // setting selection style to none so the cell doesn't turn gray or blue when touching it
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
}
