//
//  CartItem.swift
//  obligatorio1
//
//  Created by Manu on 23/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class CartItem {
    
    var id: Int?
    var quantity: Int?
    
    init(id: Int, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
    
    required init?(map: Map) {
        if map.JSON["product_id"] == nil { return nil }
        if map.JSON["quantity"] == nil { return nil }
    }
}

extension CartItem: Mappable {
    func mapping(map: Map) {
        id <- map["product_id"]
        quantity <- map["quantity"]
    }
}
