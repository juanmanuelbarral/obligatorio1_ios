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
    
    var dataManager = DataManager.sharedInstance
    var filteredSupermarketItems: [Category:[SupermarketItem]] = [:]
    var searchIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.dataSource = self
        searchBar.delegate = self
        
        // Configuring the scroll banner
        scrollBanner.numberOfPages = dataManager.getBannerItems().count
        scrollBanner.currentPage = 0
        
        updateStateCartNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // No large title
        self.title = ""
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
        
        // Reload tableView
        itemsTableView.reloadData()
    }
    
    /// Function to get the indexPath of the buttons in a cell of a tableView
    ///
    /// - Parameters:
    ///   - element: element selected
    ///   - tableView: tableView where the element is
    /// - Returns: the IndexPath of said element in the tableView
    private func getIndexPath(of element: Any, tableView: UITableView) -> IndexPath?
    {
        if let view =  element as? UIView
        {
            // Converting to table view coordinate system
            let pos = view.convert(CGPoint.zero, to: tableView)
            // Getting the index path according to the converted position
            return tableView.indexPathForRow(at: pos)
        }
        return nil
    }
    
    
    /// Function that checks if the cart navigation button should be enabled or not
    private func updateStateCartNavigationButton() {
        if dataManager.checkoutItemsIsEmpty() {
            cartNavigationButton.isEnabled = false
        } else {
            cartNavigationButton.isEnabled = true
        }
    }
    
    
    @IBAction func addButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView) {
            onAddButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView) {
            onPlusButtonClick(indexPath: indexPath)
            
        }
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView) {
            onMinusButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func cartNavigationButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "toCheckoutViewController", sender: nil)
    }
    
}


extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getBannerItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of SectionCollectionViewCell")
        }
        
        let banner = dataManager.getBannerItem(index: indexPath.row)
        cell.configCell(banner: banner)
        
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
        return dataManager.getSupermarketItems().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataManager.getCategory(index: section).rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = dataManager.getCategory(index: section)
        
        // Use all of the items or the filtered items
        var items: [Category: [SupermarketItem]]
        if searchIsActive {
            // Use the filtered items
            items = filteredSupermarketItems
        } else {
            // Use all of the items
            items = dataManager.getSupermarketItems()
        }
        
        guard let itemsInCategory = items[category] else {
            return 0
        }
        return itemsInCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: "itemTableCell", for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell")
        }
        
        // Obtain the item to config the cell
        let category = dataManager.getCategory(index: indexPath.section)
        var item: SupermarketItem
        if searchIsActive {
            // Use the filtered items
            item = filteredSupermarketItems[category]![indexPath.row]
        } else {
            // Use all of the items
            item = dataManager.getSupermarketItem(category: category, index: indexPath.row)
        }
        
        // Check it that item has units in the cart
        let checkoutItemIndex = dataManager.getCheckoutItemIndex(name: item.name)
        var units = 0
        if checkoutItemIndex != nil {
            units = dataManager.getCheckoutItem(index: checkoutItemIndex!).getUnits()
        }
        
        // Config the cell
        cell.configCell(item: item, units: units)
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    /// Function performed when the user taps on the add button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onAddButtonClick(indexPath: IndexPath) {
        let category = dataManager.getCategory(index: indexPath.section)
        let item = dataManager.getSupermarketItem(category: category, index: indexPath.row)
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        // Add item to cart with quantity in 1
        let newCheckoutItem = CheckoutItem(item: item, units: 1)
        dataManager.addCheckoutItem(newItem: newCheckoutItem)
        
        // Hide add button
        cell.addButton.isHidden = true
        
        // Set quantity label and show quantityControlView
        cell.quantityLabel.text = String(newCheckoutItem.getUnits())
        cell.quantityControlView.isHidden = false
        
        // Config the cartNavigationButton in case it was disabled
        updateStateCartNavigationButton()
        
    }
    
    /// Function performed when the user taps on the plus button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onPlusButtonClick(indexPath: IndexPath) {
        let category = dataManager.getCategory(index: indexPath.section)
        let supermarketItem = dataManager.getSupermarketItem(category: category, index: indexPath.row)
        
        guard let itemIndex = dataManager.getCheckoutItemIndex(name: supermarketItem.name)  else {
            fatalError("There should be a checkout item for \(supermarketItem.name)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        let checkoutItem = dataManager.getCheckoutItem(index: itemIndex)
        
        // Check if we are going to reach the maximum quantity
        if checkoutItem.getUnits() == (checkoutItem.getMax()-1) {
            // Disable plus button so they can't go over the maximum
            cell.plusButton.isEnabled = false
        }
        
        // Increase the checkoutItem quantity
        checkoutItem.setUnits(units: checkoutItem.getUnits()+1)
        dataManager.updateCheckoutItems(index: itemIndex, item: checkoutItem)
        // Update the quantity label
        cell.quantityLabel.text = String(checkoutItem.getUnits())
    }
    
    /// Function performed when the user taps on the minus button of the tableView cells
    ///
    /// - Parameter indexPath: indexPath from the cell where the button belongs
    private func onMinusButtonClick(indexPath: IndexPath) {
        let category = dataManager.getCategory(index: indexPath.section)
        let supermarketItem = dataManager.getSupermarketItem(category: category, index: indexPath.row)
        
        guard let itemIndex = dataManager.getCheckoutItemIndex(name: supermarketItem.name)  else {
            fatalError("There should be a checkout item for \(supermarketItem.name)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        let checkoutItem = dataManager.getCheckoutItem(index: itemIndex)
        
        // If the current quantity equals max, enable plus button again
        if checkoutItem.getUnits() == checkoutItem.getMax() {
            cell.plusButton.isEnabled = true
        }
        
        // If the current quantity is 1
        if checkoutItem.getUnits() == 1 {
            // Remove from checkoutItems
            dataManager.removeCheckoutItem(index: itemIndex)
            // Show add button
            cell.addButton.isHidden = false
            // Hide quantityControlView
            cell.quantityControlView.isHidden = true
        } else {
            // Decrease checkoutItem quantity
            checkoutItem.setUnits(units: checkoutItem.getUnits()-1)
            dataManager.updateCheckoutItems(index: itemIndex, item: checkoutItem)
            // Update the quantity label
            cell.quantityLabel.text = String(checkoutItem.getUnits())
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
            let allItems = dataManager.getSupermarketItems()
            filteredSupermarketItems = allItems.mapValues {
                // Apply a mapping function over the values of the dictionary
                (items) in (items.filter {
                    // Filter those results that match with the given conditions
                    // given conditions for the project: filters by name and category
                    (item) in checkItemForMatch(item: item, text: searchText)
                })
            }
        }
        
        // Reload tableView
        itemsTableView.reloadData()
    }
    
    
    /// Function that checks if a SupermarketItem matches a text input from the search bar.
    /// Criteria: contained on the name or category
    ///
    /// - Parameters:
    ///   - item: supermarket item to check against
    ///   - text: input from the search bar
    /// - Returns: boolean value wether it matches or no
    private func checkItemForMatch(item: SupermarketItem, text: String) -> Bool {
        if item.name.lowercased().contains(text.lowercased()) {
            return true
        } else if item.category.rawValue.lowercased().contains(text.lowercased()) {
            return true
        } else {
            return false
        }
    }
}
