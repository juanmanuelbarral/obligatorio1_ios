//
//  CheckoutItem.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class CheckoutItem {
    
    let MIN_UNITS = 0
    let MAX_UNITS = 10
    
    var product: Product
    private var _quantity: Int = 0
    var quantity: Int {
        get {
            return _quantity
        }
        
        set(newValue) {
            // According to what was said in class units are limited between 0 and 10
            // The setter controls these border issues
            if newValue < MIN_UNITS {
                self._quantity = MIN_UNITS
            } else if newValue > MAX_UNITS {
                self._quantity = MAX_UNITS
            } else {
                self._quantity = newValue
            }
        }
    }
    
    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
}
