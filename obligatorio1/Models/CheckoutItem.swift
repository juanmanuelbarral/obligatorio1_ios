//
//  CheckoutItem.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckoutItem {
    
    let MIN_QUANTITY = Constants.CheckoutItem.MIN_QUANTITY
    let MAX_QUANTITY = Constants.CheckoutItem.MAX_QUANTITY
    
    var product: Product?
    private var _quantity: Int = 0
    var quantity: Int {
        get {
            return _quantity
        }
        
        set(newValue) {
            // According to what was said in class units are limited between 0 and 10
            // The setter controls these border issues
            if newValue < MIN_QUANTITY {
                self._quantity = MIN_QUANTITY
            } else if newValue > MAX_QUANTITY {
                self._quantity = MAX_QUANTITY
            } else {
                self._quantity = newValue
            }
        }
    }
    
    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
    required init?(map: Map) {
        if map.JSON[Constants.CheckoutItem.PRODUCT_KEY] == nil { return nil }
        if map.JSON[Constants.CheckoutItem.QUANTITY_KEY] == nil { return nil }
    }
    
}

extension CheckoutItem: Mappable {
    
    func mapping(map: Map) {
        product <- map[Constants.CheckoutItem.PRODUCT_KEY]
        quantity <- map[Constants.CheckoutItem.QUANTITY_KEY]
    }
}
