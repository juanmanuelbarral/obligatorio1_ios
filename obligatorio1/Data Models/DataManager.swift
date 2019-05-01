//
//  DataManager.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation


class DataManager {
    
//    Property for the singleton
    static let sharedInstance = DataManager()
    
    private var supermarketItems: [Category:[SupermarketItem]] = [:]
    private var bannerItems: [BannerItem] = []
    
    private init() {
        
        // HARDCODED - loading of supermarketItems
        addSupermarketItem(name: "Avocado", price: 30, imageLogo: "Avocado", imageItem: "Avocado", category: Category.Veggies)
        addSupermarketItem(name: "Cucumber", price: 30, imageLogo: "Cucumber", imageItem: "Cucumber", category: Category.Veggies)
        addSupermarketItem(name: "Grapefruit", price: 45, imageLogo: "Grapefruit", imageItem: "Grapefruit-2", category: Category.Fruits)
        addSupermarketItem(name: "Kiwi", price: 30, imageLogo: "Kiwi", imageItem: "Kiwi-2", category: Category.Fruits)
        addSupermarketItem(name: "Watermelon", price: 45, imageLogo: "Watermelon", imageItem: "Watermelon-2", category: Category.Fruits)
        
        // HARCODED - loading of bannerItems
        bannerItems.append(BannerItem(name: "Brazilian Bananas", image: "Banner-1"))
        bannerItems.append(BannerItem(name: "Barbados Grapefruit", image: "Banner-2"))
        bannerItems.append(BannerItem(name: "Indian Cucumbers", image: "Banner-3"))
        bannerItems.append(BannerItem(name: "Chinese Kiwis", image: "Banner-4"))
        
    }
    
    func getBannerItems() -> [BannerItem] {
        return bannerItems
    }
    
    func getSupermarketItems() -> [Category:[SupermarketItem]] {
        return supermarketItems
    }
    
    func addSupermarketItem(name: String, price: Int, imageLogo: String, imageItem: String, category: Category) {
//        IF the category exists in the dictionary (therefore already has an item, then append another item)
//        IF NOT create the category with the supermarketItem
        if supermarketItems[category] != nil {
            supermarketItems[category]!.append(SupermarketItem(name: name, price: price, imageLogo: imageLogo, imageItem: imageItem, category: category))
        } else {
            supermarketItems.updateValue([SupermarketItem(name: name, price: price, imageLogo: imageLogo, imageItem: imageItem, category: category)], forKey: category)
        }
        
    }
}
