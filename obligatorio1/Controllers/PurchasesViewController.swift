//
//  PurchasesViewController.swift
//  obligatorio1
//
//  Created by Manu on 25/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class PurchasesViewController: UIViewController {

    @IBOutlet weak var purchasesTableView: UITableView!
    
    let modelManager = ModelManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchasesTableView.dataSource = self
        purchasesTableView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        modelManager.loadPurchases(onCompletion: { (purchases: [Purchase]?, error: Error?) in
            if let error = error {
                // TODO: show error
                print("There was a problem with the Products. ERROR: \(error.localizedDescription)")
            }
            
            if purchases != nil {
                self.purchasesTableView.reloadData()
            }
        })
        
        updateNavigationTitle()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let checkoutViewController = segue.destination as? CheckoutViewController {
            checkoutViewController.state = .READ_ONLY
        }
    }
    
    
    /// Function that updates the title in the navigation top bar
    /// No tile and large title = false for the home screen
    private func updateNavigationTitle() {
        // No large title
        self.title = "Purchases"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    

    @IBAction func seeDetailButtonClick(_ sender: Any) {
        if let indexPath = Utils.getIndexPath(of: sender, tableView: purchasesTableView) {
            onSeeDetailClick(indexPath: indexPath)
        }
    }
}


extension PurchasesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelManager.getPurchases().count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = purchasesTableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as? PurchaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of PurchaseTableViewCell")
        }
        
        // Obtain the purchase to config the cell
        let purchase = modelManager.getPurchase(index: indexPath.row)
        
        // Config the cell
        cell.configCell(item: purchase)
        
        return cell
    }
}


extension PurchasesViewController: UITableViewDelegate {
    /// Function performed when the user taps on the see detail button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onSeeDetailClick(indexPath: IndexPath) {
        let purchase = modelManager.getPurchase(index: indexPath.row)
        modelManager.purchaseCheckoutItemsRO = purchase.checkoutItems ?? []
        performSegue(withIdentifier: "toCheckoutFromPurchases", sender: nil)
    }
}
