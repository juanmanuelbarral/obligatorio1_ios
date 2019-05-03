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
    private var checkoutItems: [CheckoutItem] = []
    
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
    
    private func inRange(index: Int, count: Int) -> Bool {
        if index < count && index >= 0 {
            return true
        } else {
            return false
        }
    }
    
    // bannerItems: [BannerItem] FUNCTIONS
    func getBannerItems() -> [BannerItem] {
        return bannerItems
    }
    
    func getBannerItem(index: Int) -> BannerItem {
        if inRange(index: index, count: bannerItems.count) {
            return bannerItems[index]
        } else {
            fatalError("ERROR: index out of range in bannerItems with index \(index)")
        }
    }
    
    // supermarketItems: [Category:[SupermarketItems]] FUNCTIONS
    func getCategories() -> [Category] {
        return Category.allCases
    }
    
    func getCategory(index: Int) -> Category {
        if inRange(index: index, count: getCategories().count) {
            return getCategories()[index]
        } else {
             fatalError("ERROR: out of index in Category.allCases with index \(index)")
        }
    }
    
    func getSupermarketItems() -> [Category:[SupermarketItem]] {
        return supermarketItems
    }
    
    func getSupermarketItem(category: Category, index: Int) -> SupermarketItem {
        guard let items = supermarketItems[category] else {
            fatalError("There is no category \(category.rawValue)")
        }
        
        if inRange(index: index, count: items.count) {
            return items[index]
        } else {
            fatalError("ERROR: index out of range in supermarketItems with category \(category.rawValue) and index \(index)")
        }
        
    }
    
    func addSupermarketItem(name: String, price: Int, imageLogo: String, imageItem: String, category: Category) {
        // IF the category exists in the dictionary (therefore already has an item, then append another item)
        // IF NOT create the category with the supermarketItem
        if supermarketItems[category] != nil {
            supermarketItems[category]!.append(SupermarketItem(name: name, price: price, imageLogo: imageLogo, imageItem: imageItem, category: category))
        } else {
            supermarketItems.updateValue([SupermarketItem(name: name, price: price, imageLogo: imageLogo, imageItem: imageItem, category: category)], forKey: category)
        }
    }
    
    // checkoutItems: [CheckoutItem] FUNCTIONS
    func getCheckoutItems() -> [CheckoutItem] {
        return checkoutItems
    }
    
    func getCheckoutItem(index: Int) -> CheckoutItem {
        if inRange(index: index, count: checkoutItems.count) {
            return checkoutItems[index]
        } else {
            fatalError("ERROR: index out of range in checkoutItems with index \(index)")
        }
    }
    
    func getCheckoutItemIndex(name: String) -> Int? {
        var index = 0
        while index < checkoutItems.count {
            if checkoutItems[index].item.name == name {
                return index
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func addCheckoutItem(newItem: CheckoutItem) {
        let nameNewItem = newItem.item.name
        let alreadyExists = getCheckoutItemIndex(name: nameNewItem) != nil
        if !alreadyExists {
            checkoutItems.append(newItem)
        }
    }
    
    func updateCheckoutItems(index: Int, item: CheckoutItem) {
        if inRange(index: index, count: checkoutItems.count) {
            checkoutItems[index] = item
        }
    }
    
    func removeCheckoutItem(index: Int) {
        checkoutItems.remove(at: index)
    }
    
    func clearCheckoutItems() {
        checkoutItems = []
    }
    
    func checkoutItemsIsEmpty() -> Bool {
        if checkoutItems.count == 0 {
            return true
        } else {
            return false
        }
    }
}
