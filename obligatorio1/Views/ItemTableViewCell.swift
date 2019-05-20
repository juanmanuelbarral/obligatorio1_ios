//
//  ItemTableViewCell.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

//    OUTLETS
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityControlView: UIView!
    
//    PROPERTIES
    private var quantity = 0
    
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
    ///   - units: units of that item on the cart
    func configCell(item: Product, units: Int) {
        // Formatting the photoUrl, name and price
        itemImageView.image = UIImage(named: item.photoUrl!)
        itemImageView.layer.cornerRadius = itemImageView.frame.size.width/2
        nameLabel.text = item.name
        priceLabel.text = "$\(item.price!)"
        
        
        // Formatting the addButton, and quantityControllerView
        addButton.layer.cornerRadius = 20
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.layer.borderWidth = 1
        quantityControlView.layer.cornerRadius = 20
        quantityControlView.layer.borderColor = UIColor.lightGray.cgColor
        quantityControlView.layer.borderWidth = 1
        
        if units > 0 {
            addButton.isHidden = true
            quantityLabel.text = String(units)
            quantityControlView.isHidden = false
        } else {
            addButton.isHidden = false
            quantityLabel.text = String(units)
            quantityControlView.isHidden = true
        }
        
        // Formating the cell
        // setting selection style to none so the cell doesn't turn gray or blue when touching it
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
}
