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
    
    private var supermarketItems: [Category:[SupermarketItem]] = [:]
    private var bannerItems: [BannerItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supermarketItems = DataManager.sharedInstance.getSupermarketItems()
        bannerItems = DataManager.sharedInstance.getBannerItems()

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.dataSource = self
        
        configureCells()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        cell.nameLabel.text = banner.name
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
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
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    private func configureCells() {
        
//        itemsTableView config
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = 90
    }
    
}
