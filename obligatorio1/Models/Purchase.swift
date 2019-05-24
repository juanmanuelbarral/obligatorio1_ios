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
    var products: [CheckoutItem]?
    var total: Float = 0
    
    init(date: String, products: [CheckoutItem]) {
        self.date = date
        self.products = products
        self.total = calculateTotal()
    }
    
    required init?(map: Map) {
        if map.JSON[Constants.Purchase.DATE_KEY] == nil { return nil }
        if map.JSON[Constants.Purchase.PRODUCTS_KEY] == nil { return nil }
        self.total = calculateTotal()
    }
    
    private func calculateTotal() -> Float {
        var totalPrice: Float = 0
        guard let products = products else { return totalPrice }
        products.forEach { (item: CheckoutItem) in
            // I know price is not empry bc in the init? of Product if price==nil -> doesn't create that Product
            totalPrice += Float(item.quantity) * item.product!.price!
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
