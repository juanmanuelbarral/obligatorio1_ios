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
    
    var date: String
    var products: [CheckoutItem]
    var total: Float = 0
    
    init(date: String, products: [CheckoutItem]) {
        self.date = date
        self.products = products
        self.total = calculateTotal()
    }
    
    required init?(map: Map) {}
    
    private func calculateTotal() -> Float {
        var totalPrice: Float = 0
        products.forEach { (item: CheckoutItem) in
            // TODO: price should be checked not to be empty
            totalPrice += Float(item.quantity) * item.product.price!
        }
        return totalPrice
    }
}

extension Purchase: Mappable {
    
    func mapping(map: Map) {
        date <- map[Constants.Purchase.DATE_KEY]
        products <- map[Constants.Purchase.PRODUCTS_KEY]
    }
}
