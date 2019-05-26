//
//  HomeViewController.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // OUTLETS
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var scrollBanner: UIPageControl!
    @IBOutlet weak var cartNavigationButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var modelManager = ModelManager.sharedInstance
    var filteredProducts: [String:[Product]] = [:]
    var searchIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.dataSource = self
        searchBar.delegate = self
        
        configScrollBanner()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        modelManager.loadProducts { (products: [Product]?, error: Error?) in
            if let error = error {
                // TODO: show error
                print("There was a problem with the Products. ERROR: \(error.localizedDescription)")
            }
            if products != nil {
                self.itemsTableView.reloadData()
            }
        }
        
        modelManager.loadPromotions { (promotions: [Promotion]?, error: Error?) in
            if let error = error {
                // TODO: show error
                print("There was a problem with the Promotions. ERROR: \(error.localizedDescription)")
            }
            if promotions != nil {
                self.bannerCollectionView.reloadData()
                self.configScrollBanner()
            }
        }
        
        updateNavigationTitle()
        updateStateCartNavigationButton()
    }
    
    
    /// Function that updates the title in the navigation top bar
    /// No tile and large title = false for the home screen
    private func updateNavigationTitle() {
        // No large title
        //self.title = ""
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    
    /// Function that checks if the cart navigation button should be enabled or not
    private func updateStateCartNavigationButton() {
        if modelManager.checkoutItemsIsEmpty() {
            cartNavigationButton.isEnabled = false
        } else {
            cartNavigationButton.isEnabled = true
        }
    }
    
    
    /// Configure the scroll banner
    private func configScrollBanner() {
        scrollBanner.numberOfPages = modelManager.getPromotions().count
        scrollBanner.currentPage = 0
    }
    
    
    @IBAction func addButtonClick(_ sender: Any) {
        if let indexPath = Utils.getIndexPath(of: sender, tableView: itemsTableView) {
            onAddButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        if let indexPath = Utils.getIndexPath(of: sender, tableView: itemsTableView) {
            onPlusButtonClick(indexPath: indexPath)
            
        }
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        if let indexPath = Utils.getIndexPath(of: sender, tableView: itemsTableView) {
            onMinusButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func cartNavigationButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "toCheckoutFromHome", sender: nil)
    }
    
}


extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelManager.getPromotions().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of BannerCollectionViewCell")
        }
        
        let banner = modelManager.getPromotion(index: indexPath.row)
        cell.configCell(promotion: banner)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bannerCollectionViewSize = bannerCollectionView.frame.size
        let height = bannerCollectionViewSize.height
        let width = bannerCollectionViewSize.width
        return CGSize(width: width, height: height)
    }
    
    
    // Function for changing the scroll of the banner
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        scrollBanner.currentPage = indexPath.row
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelManager.getProducts().count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return modelManager.getCategory(index: section)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = modelManager.getCategory(index: section)
        
        // Use all of the items or the filtered items
        var products: [String: [Product]]
        if searchIsActive {
            // Use the filtered products
            products = filteredProducts
        } else {
            // Use all of the products
            products = modelManager.getProducts()
        }
        
        guard let productsInCategory = products[category] else {
            return 0
        }
        return productsInCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: "itemTableCell", for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell")
        }
        
        // Obtain the product to config the cell
        let category = modelManager.getCategory(index: indexPath.section)
        var product: Product
        if searchIsActive {
            // Use the filtered products
            product = filteredProducts[category]![indexPath.row]
        } else {
            // Use all of the products
            product = modelManager.getProduct(category: category, index: indexPath.row)
        }
        
        // Check if that item has units in the cart
        let checkoutItemIndex = modelManager.getCheckoutItemIndex(name: product.name!)
        var units = 0
        if checkoutItemIndex != nil {
            units = modelManager.getCheckoutItem(index: checkoutItemIndex!).quantity!
        }
        
        // Config the cell
        cell.configCell(item: product, units: units)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    /// Function performed when the user taps on the add button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onAddButtonClick(indexPath: IndexPath) {
        let category = modelManager.getCategory(index: indexPath.section)
        let product = modelManager.getProduct(category: category, index: indexPath.row)
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        // Add item to cart with quantity in 1
        let newCheckoutItem = CheckoutItem(product: product, quantity: 1)
        modelManager.addCheckoutItem(newItem: newCheckoutItem)
        
        // Hide add button
        cell.addButton.isHidden = true
        
        // Set quantity label and show quantityControlView
        cell.quantityLabel.text = String(newCheckoutItem.quantity!)
        cell.quantityControlView.isHidden = false
        
        // Config the cartNavigationButton in case it was disabled
        updateStateCartNavigationButton()
        
    }
    
    
    /// Function performed when the user taps on the plus button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onPlusButtonClick(indexPath: IndexPath) {
        let category = modelManager.getCategory(index: indexPath.section)
        let product = modelManager.getProduct(category: category, index: indexPath.row)
        
        guard let itemIndex = modelManager.getCheckoutItemIndex(name: product.name!)  else {
            fatalError("There should be a checkout item for \(product.name!)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        let checkoutItem = modelManager.getCheckoutItem(index: itemIndex)
        
        // Check if we are going to reach the maximum quantity (or already the maximum)
        if checkoutItem.quantity! >= (checkoutItem.MAX_QUANTITY-1) {
            // Disable plus button so they can't go over the maximum
            cell.plusButton.isEnabled = false
        }
        
        // Increase the checkoutItem quantity
        checkoutItem.quantity! = checkoutItem.quantity!+1
        modelManager.updateCheckoutItems(index: itemIndex, item: checkoutItem)
        // Update the quantity label
        cell.quantityLabel.text = String(checkoutItem.quantity!)
    }
    
    
    /// Function performed when the user taps on the minus button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onMinusButtonClick(indexPath: IndexPath) {
        let category = modelManager.getCategory(index: indexPath.section)
        let product = modelManager.getProduct(category: category, index: indexPath.row)
        
        guard let itemIndex = modelManager.getCheckoutItemIndex(name: product.name!)  else {
            fatalError("There should be a checkout item for \(product.name!)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        let checkoutItem = modelManager.getCheckoutItem(index: itemIndex)
        
        // If the current quantity equals max, enable plus button again
        if checkoutItem.quantity == checkoutItem.MAX_QUANTITY {
            cell.plusButton.isEnabled = true
        }
        
        // If the current quantity is 1
        if checkoutItem.quantity == 1 {
            // Remove from checkoutItems
            modelManager.removeCheckoutItem(index: itemIndex)
            // Show add button
            cell.addButton.isHidden = false
            // Hide quantityControlView
            cell.quantityControlView.isHidden = true
        } else {
            // Decrease checkoutItem quantity
            checkoutItem.quantity = checkoutItem.quantity!-1
            modelManager.updateCheckoutItems(index: itemIndex, item: checkoutItem)
            // Update the quantity label
            cell.quantityLabel.text = String(checkoutItem.quantity!)
        }
        
        // Config the cartNavigationButton in case the checkoutItems became empty
        updateStateCartNavigationButton()
    }
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if there is text in the search bar to filter items
        if searchText == "" {
            searchIsActive = false
        } else {
            searchIsActive = true
        }
        
        // If the search is active then filter the items
        if searchIsActive {
            let allItems = modelManager.getProducts()
            filteredProducts = allItems.mapValues {
                // Apply a mapping function over the values of the dictionary
                (items) in (items.filter {
                    // Filter those results that match with the given conditions
                    // given conditions for the project: filters by name and category
                    (item) in checkItemForMatch(product: item, text: searchText)
                })
            }
        }
        
        // Reload tableView
        itemsTableView.reloadData()
    }
    
    
    /// Function that checks if a Product matches a text input from the search bar.
    /// Criteria: contained on the name or category
    ///
    /// - Parameters:
    ///   - item: supermarket item to check against
    ///   - text: input from the search bar
    /// - Returns: boolean value wether it matches or no
    private func checkItemForMatch(product: Product, text: String) -> Bool {
        if product.name!.lowercased().contains(text.lowercased()) {
            return true
        } else if product.category!.lowercased().contains(text.lowercased()) {
            return true
        } else {
            return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
