//
//  ModelManager.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation


class ModelManager {
    
//    Property for the singleton
    static let sharedInstance = ModelManager()
    
    private var products: [Category:[Product]] = [:]
    private var promotions: [Promotion] = []
    private var checkoutItems: [CheckoutItem] = []
    
    private init() {
        
        // HARDCODED - loading of products
//        addProduct(name: "Avocado", price: 30, imageLogo: "Avocado", imageItem: "Avocado", category: Category.Veggies)
//        addProduct(name: "Cucumber", price: 30, imageLogo: "Cucumber", imageItem: "Cucumber", category: Category.Veggies)
//        addProduct(name: "Grapefruit", price: 45, imageLogo: "Grapefruit", imageItem: "Grapefruit-2", category: Category.Fruits)
//        addProduct(name: "Kiwi", price: 30, imageLogo: "Kiwi", imageItem: "Kiwi-2", category: Category.Fruits)
//        addProduct(name: "Watermelon", price: 45, imageLogo: "Watermelon", imageItem: "Watermelon-2", category: Category.Fruits)
        
        // HARCODED - loading of promotions
//        promotions.append(Promotion(name: "Brazilian Bananas", photoUrl: "Banner-1"))
//        promotions.append(Promotion(name: "Barbados Grapefruit", photoUrl: "Banner-2"))
//        promotions.append(Promotion(name: "Indian Cucumbers", photoUrl: "Banner-3"))
//        promotions.append(Promotion(name: "Chinese Kiwis", photoUrl: "Banner-4"))
        
    }
    
    private func inRange(index: Int, count: Int) -> Bool {
        if index < count && index >= 0 {
            return true
        } else {
            return false
        }
    }
    
    // promotions: [Promotion] FUNCTIONS
    func getPromotions() -> [Promotion] {
        return promotions
    }
    
    func getPromotion(index: Int) -> Promotion {
        if inRange(index: index, count: promotions.count) {
            return promotions[index]
        } else {
            fatalError("ERROR: index out of range in promotions with index \(index)")
        }
    }
    
    // products: [Category:[SupermarketItems]] FUNCTIONS
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
    
    func getProducts() -> [Category:[Product]] {
        return products
    }
    
    func getProduct(category: Category, index: Int) -> Product {
        guard let items = products[category] else {
            fatalError("There is no category \(category.rawValue)")
        }
        
        if inRange(index: index, count: items.count) {
            return items[index]
        } else {
            fatalError("ERROR: index out of range in products with category \(category.rawValue) and index \(index)")
        }
        
    }
    
    func addProduct(id: Int, name: String, price: Float, photoUrl: String, category: Category) {
        // IF the category exists in the dictionary (therefore already has an item, then append another item)
        // IF NOT create the category with the supermarketItem
        if products[category] != nil {
            products[category]!.append(Product(id: id, name: name, price: price, photoUrl: photoUrl, category: category))
        } else {
            products.updateValue([Product(id: id, name: name, price: price, photoUrl: photoUrl, category: category)], forKey: category)
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
    
    // TODO: change this for getCheckoutItem(name: String) -> CheckoutItem?
    func getCheckoutItemIndex(name: String) -> Int? {
        var index = 0
        while index < checkoutItems.count {
            if checkoutItems[index].product.name == name {
                return index
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func addCheckoutItem(newItem: CheckoutItem) {
        let nameNewItem = newItem.product.name
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
        return checkoutItems.isEmpty
    }
}
