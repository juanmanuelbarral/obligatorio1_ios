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
    
    private let apiManager = ApiManager.sharedInstance
    private var productCategories: [String] = []
    private var products: [String:[Product]] = [:]
    private var promotions: [Promotion] = []
    private var checkoutItems: [CheckoutItem] = []
    private var purchases: [Purchase] = []
    
    private init() {
        
        // Load data from API
        loadProducts()
        loadPromotions()
        loadPurchases()
    }
    
    private func inRange(index: Int, count: Int) -> Bool {
        if index < count && index >= 0 {
            return true
        } else {
            return false
        }
    }
    
    
    // promotions: [Promotion] FUNCTIONS
    private func loadPromotions() {
        if let promotionsResponse = apiManager.getPromotions() {
            promotions = promotionsResponse
        } else {
            promotions = []
        }
    }
    
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
    
    
    // products: [String:[SupermarketItems]] FUNCTIONS
    private func loadProducts() {
        if let productsResponse = apiManager.getProducts() {
            productsResponse.forEach { (product) in
                let category = product.category ?? Constants.Product.CATEGORY_DEFAULT_VALUE
                
                // IF the category exists in the dictionary -> append another product
                // IF NOT create the category with the new product
                if products[category] != nil {
                    products[category]!.append(product)
                } else {
                    productCategories.append(category)
                    products.updateValue([product], forKey: category)
                }
            }
        } else {
            products = [:]
        }
    }
    
    func getCategories() -> [String] {
        return productCategories
    }
    
    func getCategory(index: Int) -> String {
        if inRange(index: index, count: getCategories().count) {
            return getCategories()[index]
        } else {
             fatalError("ERROR: out of index in productCateogories with index \(index)")
        }
    }
    
    func getProducts() -> [String:[Product]] {
        return products
    }
    
    func getProduct(category: String, index: Int) -> Product {
        guard let productsInCategory = products[category] else {
            fatalError("There is no category \(category)")
        }
        
        if inRange(index: index, count: productsInCategory.count) {
            return productsInCategory[index]
        } else {
            fatalError("ERROR: index out of range in products with category \(category) and index \(index)")
        }
    }
    
    //    TODO: addProduct necesary?
    func addProduct(id: Int, name: String, price: Float, photoUrl: String, category: String) {
        let newProduct = Product(id: id, name: name, price: price, photoUrl: photoUrl, category: category)
        // IF the category exists in the dictionary -> append another product
        // IF NOT create the category with the new product
        if products[category] != nil {
            products[category]!.append(newProduct)
        } else {
            productCategories.append(category)
            products.updateValue([newProduct], forKey: category)
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
            if checkoutItems[index].product.name == name {
                return index
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func addCheckoutItem(newItem: CheckoutItem) {
        let nameNewItem = newItem.product.name!
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
    
    
    // purchases: [Purchase] FUNCTIONS
    func loadPurchases() {
        if let purchasesResponse = apiManager.getPurchases() {
            purchases = purchasesResponse
        } else {
            purchases = []
        }
    }
}
