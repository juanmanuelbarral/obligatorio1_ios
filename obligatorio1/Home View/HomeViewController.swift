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
    
    private var supermarketItems: [Category:[SupermarketItem]] = [:]
    private var bannerItems: [BannerItem] = []
    private var checkoutItems: [String:CheckoutItem] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supermarketItems = DataManager.sharedInstance.getSupermarketItems()
        bannerItems = DataManager.sharedInstance.getBannerItems()

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.dataSource = self
        
        configureCells()
        
        // Configuring the scroll banner
        scrollBanner.numberOfPages = bannerItems.count
        scrollBanner.currentPage = 0
    }
    
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
    
    @IBAction func addButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView)
        {
            onAddButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView)
        {
            onPlusButtonClick(indexPath: indexPath)
        }
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        if let indexPath = getIndexPath(of: sender, tableView: itemsTableView)
        {
            onMinusButtonClick(indexPath: indexPath)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of SectionCollectionViewCell")
        }
        
        let banner = bannerItems[indexPath.row]
        cell.bannerImageView.image = UIImage(named: banner.image)
        cell.bannerImageView.layer.cornerRadius = 5
        cell.nameLabel.text = banner.name
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        scrollBanner.currentPage = indexPath.row
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return supermarketItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Category.allCases[section].rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        guard let itemsCategory = supermarketItems[category] else {
            return 0
        }
        
        return itemsCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemsTableView.dequeueReusableCell(withIdentifier: "itemTableCell", for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell")
        }
        
        let category = Category.allCases[indexPath.section]
        let item = supermarketItems[category]![indexPath.row]
        
        // Formatting the image, name and price
        cell.itemImageView.image = UIImage(named: item.imageLogo)
        cell.itemImageView.layer.cornerRadius = cell.itemImageView.frame.size.width/2
        cell.nameLabel.text = item.name
        cell.priceLabel.text = item.getPriceString()
        
        // Formatting the addButton, and quantityControllerView
        cell.addButton.isHidden = false
        cell.addButton.layer.cornerRadius = 20
        cell.addButton.layer.borderColor = UIColor.blue.cgColor
        cell.addButton.layer.borderWidth = 1
        cell.quantityControlView.isHidden = true
        cell.quantityControlView.layer.cornerRadius = 20
        cell.quantityControlView.layer.borderColor = UIColor.lightGray.cgColor
        cell.quantityControlView.layer.borderWidth = 1
        
        // Formating the cell
        // setting selection style to none so the cell doesn't turn gray or blue when touching it
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    private func configureCells() {
        
//        itemsTableView config
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = 90
    }
    
    private func onAddButtonClick(indexPath: IndexPath) {
        
        let category = Category.allCases[indexPath.section]
        let item = supermarketItems[category]![indexPath.row]
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        // Add item to cart with quantity in 1
        let newCheckoutItem = CheckoutItem(item: item, units: 1)
        checkoutItems.updateValue(newCheckoutItem, forKey: item.name)
        // Hide add button
        cell.addButton.isHidden = true
        // Set quantity label and show quantityControlView
        cell.quantityLabel.text = String(newCheckoutItem.getUnits())
        cell.quantityControlView.isHidden = false
        
    }
    
    private func onPlusButtonClick(indexPath: IndexPath) {
        
        let category = Category.allCases[indexPath.section]
        let supermarketItem = supermarketItems[category]![indexPath.row]
        guard let checkoutItem = checkoutItems[supermarketItem.name]  else {
            fatalError("There should be a checkout item for \(supermarketItem.name)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        // Check if we are going to reach the maximum quantity
        if checkoutItem.getUnits() == (checkoutItem.getMax()-1) {
            // Disable plus button so they can't go over the maximum
            cell.plusButton.isEnabled = false
        }
        
        // Increase the checkoutItem quantity
        checkoutItem.setUnits(units: checkoutItem.getUnits()+1)
        checkoutItems.updateValue(checkoutItem, forKey: supermarketItem.name)
        // Update the quantity label
        cell.quantityLabel.text = String(checkoutItem.getUnits())
    }
    
    private func onMinusButtonClick(indexPath: IndexPath) {
        
        let category = Category.allCases[indexPath.section]
        let supermarketItem = supermarketItems[category]![indexPath.row]
        guard let checkoutItem = checkoutItems[supermarketItem.name]  else {
            fatalError("There should be a checkout item for \(supermarketItem.name)")
        }
        guard let cell = itemsTableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            fatalError("The cell is not ItemTableViewCell type")
        }
        
        // If the current quantity equals max, enable plus button again
        if checkoutItem.getUnits() == checkoutItem.getMax() {
            cell.plusButton.isEnabled = true
        }
        
        // If the current quantity is 1
        if checkoutItem.getUnits() == 1 {
            // Remove from checkoutItems
            checkoutItems.removeValue(forKey: supermarketItem.name)
            print(checkoutItems)
            // Show add button
            cell.addButton.isHidden = false
            // Hide quantityControlView
            cell.quantityControlView.isHidden = true
        } else {
            // Decrease checkoutItem quantity
            checkoutItem.setUnits(units: checkoutItem.getUnits()-1)
            checkoutItems.updateValue(checkoutItem, forKey: supermarketItem.name)
            // Update the quantity label
            cell.quantityLabel.text = String(checkoutItem.getUnits())
        }
    }
    
}
