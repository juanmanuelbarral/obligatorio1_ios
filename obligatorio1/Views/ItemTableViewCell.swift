//
//  ItemTableViewCell.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

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
    var delegate: ItemCellDelegate?
    var _product: Product?
    var _quantity: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Function that configures the cell with its needed information
    ///
    /// - Parameters:
    ///   - item: item to be reflected on the cell
    ///   - units: units of that item on the cart
    func configCell(product: Product, quantity: Int) {
        self._product = product
        self._quantity = quantity
        
        // Formatting the photoUrl, name and price
        itemImageView.kf.setImage(with: URL(string: product.photoUrl!))
        itemImageView.layer.cornerRadius = itemImageView.frame.size.width/2
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price!)"
        
        
        // Formatting the addButton, and quantityControllerView
        addButton.layer.cornerRadius = 20
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.layer.borderWidth = 1
        quantityControlView.layer.cornerRadius = 20
        quantityControlView.layer.borderColor = UIColor.lightGray.cgColor
        quantityControlView.layer.borderWidth = 1
        
        if quantity > 0 {
            addButton.isHidden = true
            quantityLabel.text = String(quantity)
            quantityControlView.isHidden = false
        } else {
            addButton.isHidden = false
            quantityLabel.text = String(quantity)
            quantityControlView.isHidden = true
        }
        
        // Formating the cell
        // setting selection style to none so the cell doesn't turn gray or blue when touching it
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        if let delegate = delegate {
            delegate.onAddButtonClick(cell: self)
        }
        
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        if let delegate = delegate {
            delegate.onPlusButtonClick(cell: self)
        }
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        if let delegate = delegate {
            delegate.onMinusButtonClick(cell: self)
        }
    }
}
