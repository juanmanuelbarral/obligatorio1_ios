//
//  CheckoutViewController.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

enum CheckoutState {
    case NORMAL
    case READ_ONLY
}

class CheckoutViewController: UIViewController {

    // OUTLET
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var checkoutButtonBottomMargin: NSLayoutConstraint!
    
    private var modelManager = ModelManager.sharedInstance
    private var pickerChoices: [Int] = [Int](0...10)
    private var selectedOptionPicker = 0
    private var pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    var state: CheckoutState = CheckoutState.NORMAL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Checkout button style and state
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch state {
        case .NORMAL:
            updateNavigationTitle(title: "Shopping Cart", prefersLargeTitles: true)
            updateStateCheckoutButton()
        
        case .READ_ONLY:
            updateNavigationTitle(title: "Detail", prefersLargeTitles: true)
            
            // checkout button GONE
            checkoutButton.isHidden = true
            checkoutButton.isEnabled = false
            checkoutButtonHeight.constant = 0
            checkoutButtonBottomMargin.constant = 0
        }
        
        // Call function to update total price
        updateTotalPrice()
    }
    
    
    /// Calculates the price of all the items in the cart
    ///
    /// - Returns: total price as a Float
    private func calculateTotalPrice() -> Float {
        var totalPrice: Float = 0
        // Depending on the state which checkoutItems use
        let checkoutItems: [CheckoutItem] = state == .NORMAL ? modelManager.getCheckoutItems() : modelManager.purchaseCheckoutItemsRO
        
        checkoutItems.forEach { (item) in
            totalPrice += Float(item.quantity!) * item.product!.price!
        }
        return totalPrice
    }
    
    
    /// Updates the total price label on the view
    private func updateTotalPrice() {
        finalPriceLabel.text = "$\(calculateTotalPrice())"
    }
    
    
    /// Function that updates the title in the navigation top bar
    /// Large title = true for the checkout screen
    private func updateNavigationTitle(title: String, prefersLargeTitles: Bool) {
        // Large title
        self.title = title
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    
    /// Updates the checkout button appearance and state whether it should be enabled or not
    private func updateStateCheckoutButton() {
        if modelManager.checkoutItemsIsEmpty() {
            checkoutButton.isEnabled = false
            checkoutButton.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            checkoutButton.isEnabled = true
            checkoutButton.layer.backgroundColor = UIColor.blue.cgColor
        }
    }
    
    
    @IBAction func checkoutButtonClick(_ sender: Any) {
        modelManager.postCheckoutItems { (successMessage, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Oops! there was a problem", message: error.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    print("Cancel button tapped")
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if let successMessage = successMessage {
                // Show alert that the transaction was succesful
                let alertController = UIAlertController(title: "Success!", message: successMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // Empty the checkoutItems
                    self.modelManager.clearCheckoutItems()
                    
                    // Remove self from the navigation stack
                    self.navigationController?.viewControllers.removeLast()
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Depending on the state which checkoutItems use
        let checkoutItems: [CheckoutItem] = state == .NORMAL ? modelManager.getCheckoutItems() : modelManager.purchaseCheckoutItemsRO
        
        return checkoutItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "cartCollectionCell", for: indexPath) as? CartCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CartCollectionViewCell")
        }
        
        // Depending on the state which checkoutItem use
        let checkoutItem = state == .NORMAL ? modelManager.getCheckoutItem(index: indexPath.row) : modelManager.purchaseCheckoutItemsRO[indexPath.row]
        
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
        if state == .NORMAL {
            // Alert with picker
            let alertController = UIAlertController(title: "Change the units", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            alertController.view.addSubview(pickerView)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // Change the units for the checkoutItem to the selected option or remove if cero
                if self.selectedOptionPicker != 0 {
                    let changedItem = self.modelManager.getCheckoutItems()[indexPath.row]
                    changedItem.quantity = self.selectedOptionPicker
                    self.modelManager.updateCheckoutItems(index: indexPath.row, item: changedItem)
                } else {
                    self.modelManager.removeCheckoutItem(index: indexPath.row)
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
