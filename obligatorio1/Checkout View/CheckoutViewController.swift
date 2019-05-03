//
//  CheckoutViewController.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

    // OUTLET
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    private var dataManager = DataManager.sharedInstance
    private var totalPrice: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        
        // Checkout button style
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        
        // Call function to calculate total price
        totalPrice = calculateTotalPrice()
        finalPriceLabel.text = "$\(totalPrice)"
    }
    
    private func calculateTotalPrice() -> Int {
        var totalPrice = 0
        for checkoutItem in dataManager.getCheckoutItems() {
            totalPrice += checkoutItem.getUnits() * checkoutItem.item.price
        }
        return totalPrice
    }
    

}

extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getCheckoutItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "cartCollectionCell", for: indexPath) as? CartCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CartCollectionViewCell")
        }
        
        let checkoutItem = dataManager.getCheckoutItem(index: indexPath.row)
        let supermarketItem = checkoutItem.item
        
        cell.cartItemImage.image = UIImage(named: supermarketItem.imageItem)
        cell.cartItemImage.layer.cornerRadius = 5
        cell.nameLabel.text = supermarketItem.name
        cell.priceLabel.text = supermarketItem.getPriceString()
        cell.unitsLabel.text = "\(checkoutItem.getUnits()) units"

        return cell
    }
    
}

extension CheckoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cartCollectionViewSize = cartCollectionView.frame.size
        // Half the width of the collectionView (so only two show per row)
        let width = cartCollectionViewSize.width * 0.45
        let height = width + 80
        return CGSize(width: width, height: height)
    }
}
