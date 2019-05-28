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
    
    private var modelManager = ModelManager.sharedInstance
    private var vcUtils = ViewControllerUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchasesTableView.dataSource = self
        purchasesTableView.delegate = self
        
        // start loader
        vcUtils.showActivityIndicatory(uiView: self.view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        modelManager.loadPurchases(onCompletion: { (purchases: [Purchase]?, error: Error?) in
            // stop loader
            self.vcUtils.hideActivityIndicator(uiView: self.view)
            
            if let error = error {
                let errorAlert = self.vcUtils.errorAlert(title: "Oops! something went wrong", message: "There was a problem loading your purchase history, check that you are online")
                self.present(errorAlert, animated: true, completion: nil)
                print("There was a problem with the Purchases. ERROR: \(error.localizedDescription)")
            }
            
            if purchases != nil {
                self.purchasesTableView.reloadData()
                if purchases!.isEmpty {
                    let errorAlert = self.vcUtils.errorAlert(title: "Empty list", message: "Looks like you haven't made any purchase yet")
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        })
        
        vcUtils.updateNavigationTitle(element: self, title: "Purchases", prefersLargeTitles: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let checkoutViewController = segue.destination as? CheckoutViewController {
            checkoutViewController.state = .READ_ONLY
        }
    }
    

    @IBAction func detailButtonClick(_ sender: Any) {
        if let indexPath = vcUtils.getIndexPath(of: sender, tableView: purchasesTableView) {
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
