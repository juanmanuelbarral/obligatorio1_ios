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
    var purchaseCheckoutItemsRO: [CheckoutItem] = []
    
    
    private init() {}
    
    private func inRange(index: Int, count: Int) -> Bool {
        if index < count && index >= 0 {
            return true
        } else {
            return false
        }
    }
    
    
    // promotions: [Promotion] FUNCTIONS
    func loadPromotions(onCompletion: @escaping ([Promotion]?, Error?) -> Void) {
        apiManager.getPromotions { (response: [Promotion]?, error: Error?) in
            if let error = error {
                onCompletion(nil, error)
            }
            
            if let promotionsResponse = response {
                self.promotions = promotionsResponse
                onCompletion(promotionsResponse, nil)
            }
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
    func loadProducts(onCompletion: @escaping ([Product]?, Error?) -> Void) {
        apiManager.getProducts { (response: [Product]?, error: Error?) in
            if let error = error {
                onCompletion(nil, error)
            }
            if let productsResponse = response {
                self.products = [:]
                productsResponse.forEach { (product) in
                    let category = product.category ?? Constants.Product.CATEGORY_DEFAULT_VALUE
                    
                    // IF the category exists in the dictionary -> append another product
                    // IF NOT create the category with the new product
                    if self.products[category] != nil {
                        self.products[category]!.append(product)
                    } else {
                        self.productCategories.append(category)
                        self.products.updateValue([product], forKey: category)
                    }
                }
                onCompletion(productsResponse, nil)
            }
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
    
    
    // checkoutItems: [CheckoutItem] FUNCTIONS
    func postCheckoutItems(onCompletion: @escaping (String?, Error?) -> Void) {
        var cartItemsJSON: [CartItem] = []
        checkoutItems.forEach { (checkoutItem) in
            let cartItem = CartItem(id: checkoutItem.product!.id!, quantity: checkoutItem.quantity!)
            cartItemsJSON.append(cartItem)
        }
        print(cartItemsJSON.toJSON())
        apiManager.postCheckout(checkoutItemsJSON: cartItemsJSON.toJSON(), onCompletion: { (response: String?, error: Error?) in
            if let error = error {
                onCompletion(nil, error)
            }

            if let response = response {
                onCompletion(response, nil)
            }
        })
    }
    
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
            if checkoutItems[index].product!.name == name {
                return index
            } else {
                index += 1
            }
        }
        return nil
    }
    
    func addCheckoutItem(newItem: CheckoutItem) {
        let nameNewItem = newItem.product!.name!
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
    func loadPurchases(onCompletion: @escaping ([Purchase]?, Error?) -> Void) {
        apiManager.getPurchases { (response: [Purchase]?, error: Error?) in
            if let error = error {
                onCompletion(nil, error)
            }
            
            if let purchasesResponse = response {
                self.purchases = purchasesResponse.reversed()
                onCompletion(purchasesResponse.reversed(), nil)
            }
        }
    }
    
    func getPurchases() -> [Purchase] {
        return purchases
    }
    
    func getPurchase(index: Int) -> Purchase {
        if inRange(index: index, count: purchases.count) {
            return purchases[index]
        } else {
            fatalError("ERROR: index out of range in purchases with index \(index)")
        }
    }
}
