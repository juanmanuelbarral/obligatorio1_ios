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
        
        // Checkout button style and state
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        updateStateCheckoutButton()
        
        // Call function to calculate total price
        totalPrice = calculateTotalPrice()
        finalPriceLabel.text = "$\(totalPrice)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Large title
        self.title = "Shopping cart"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    private func calculateTotalPrice() -> Int {
        var totalPrice = 0
        for checkoutItem in dataManager.getCheckoutItems() {
            totalPrice += checkoutItem.getUnits() * checkoutItem.item.price
        }
        return totalPrice
    }
    
    private func updateStateCheckoutButton() {
        if dataManager.checkoutItemsIsEmpty() {
            checkoutButton.isEnabled = false
        } else {
            checkoutButton.isEnabled = true
        }
    }
    
    @IBAction func checkoutButtonClick(_ sender: Any) {
        // Show alert that the transaction was succesful
        let alertController = UIAlertController(title: "Success!", message: "The transaction was successful", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Empty the checkoutItems
            self.dataManager.clearCheckoutItems()
            
            // Remove self from the navigation stack
            self.navigationController?.viewControllers.removeLast()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
        cell.configCell(checkoutItem: checkoutItem)
        
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
