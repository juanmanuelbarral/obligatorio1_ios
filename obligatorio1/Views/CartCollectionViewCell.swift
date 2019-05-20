//
//  CartCollectionViewCell.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    
    // OUTLETS
    @IBOutlet weak var cartItemImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    /// Function that configures the cell with its needed information
    ///
    /// - Parameter checkoutItem: checkoutItem to be reflected on the cell
    func configCell(checkoutItem: CheckoutItem) {
        cartItemImage.image = UIImage(named: checkoutItem.product.photoUrl!)
        cartItemImage.layer.cornerRadius = 5
        nameLabel.text = checkoutItem.product.name
        priceLabel.text = "$\(checkoutItem.product.price!)"
        unitsLabel.text = "\(checkoutItem.quantity) units"
    }
}
