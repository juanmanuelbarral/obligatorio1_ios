//
//  Purchase.swift
//  obligatorio1
//
//  Created by Manu on 16/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class Purchase {
    
    var date: String
    var products: [CheckoutItem]
    var total: Float = 0
    
    init(date: String, products: [CheckoutItem]) {
        self.date = date
        self.products = products
        self.total = calculateTotal()
    }
    
    private func calculateTotal() -> Float {
        var totalPrice: Float = 0
        products.forEach { (item: CheckoutItem) in
            totalPrice += Float(item.quantity) * item.product.price
        }
        return totalPrice
    }
}
