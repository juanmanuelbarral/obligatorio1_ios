//
//  Purchase.swift
//  obligatorio1
//
//  Created by Manu on 16/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Purchase {
    
    var date: String?
    var checkoutItems: [CheckoutItem]?
    var total: Float = 0
    
    init(date: String, products: [CheckoutItem]) {
        self.date = date
        self.checkoutItems = products
        self.total = calculateTotal()
    }
    
    required init?(map: Map) {
        if map.JSON[Constants.Purchase.DATE_KEY] == nil { return nil }
        if map.JSON[Constants.Purchase.PRODUCTS_KEY] == nil { return nil }
    }
    
    private func calculateTotal() -> Float {
        var totalPrice: Float = 0
        guard let products = checkoutItems else { return totalPrice }
        products.forEach { (item: CheckoutItem) in
            if let product = item.product {
                let price = product.price ?? 0
                totalPrice += Float(item.quantity) * price
            }
        }
        return totalPrice
    }
}

extension Purchase: Mappable {
    
    func mapping(map: Map) {
        date <- map[Constants.Purchase.DATE_KEY]
        checkoutItems <- map[Constants.Purchase.PRODUCTS_KEY]
        total = calculateTotal()
    }
}
