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
    
    private var dataManager = ModelManager.sharedInstance
    private var pickerChoices: [Int] = [Int](0...10)
    private var selectedOptionPicker = 0
    private var pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Checkout button style and state
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        updateStateCheckoutButton()
        
        // Call function to update total price
        updateTotalPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Large title
        self.title = "Shopping cart"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    /// Calculates the price of all the items in the cart
    ///
    /// - Returns: total price as an Int
    private func calculateTotalPrice() -> Int {
        var totalPrice = 0
        for checkoutItem in dataManager.getCheckoutItems() {
            totalPrice += checkoutItem.quantity * checkoutItem.product.price
        }
        return totalPrice
    }
    
    /// Updates the total price label on the view
    private func updateTotalPrice() {
        finalPriceLabel.text = "$\(calculateTotalPrice())"
    }
    
    /// Updates the checkout button appearance and state whether it should be enabled or not
    private func updateStateCheckoutButton() {
        if dataManager.checkoutItemsIsEmpty() {
            checkoutButton.isEnabled = false
            checkoutButton.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            checkoutButton.isEnabled = true
            checkoutButton.layer.backgroundColor = UIColor.blue.cgColor
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Alert with picker
        let alertController = UIAlertController(title: "Change the units", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alertController.view.addSubview(pickerView)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Change the units for the checkoutItem to the selected option or remove if cero
            if self.selectedOptionPicker != 0 {
                let changedItem = self.dataManager.getCheckoutItems()[indexPath.row]
                changedItem.quantity = self.selectedOptionPicker
                self.dataManager.updateCheckoutItems(index: indexPath.row, item: changedItem)
            } else {
                self.dataManager.removeCheckoutItem(index: indexPath.row)
            }
            
            // Reload the collectionView and calculate the total
            self.cartCollectionView.reloadData()
            self.updateTotalPrice()
            
            // Check for the checkout button
            self.updateStateCheckoutButton()
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CheckoutViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerChoices[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOptionPicker = pickerChoices[row]
    }
}
