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
    
    var date: Date?
    var checkoutItems: [CheckoutItem]?
    var total: Float = 0
    
    init(date: Date, products: [CheckoutItem]) {
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
                let quantity = item.quantity ?? 0
                let price = product.price ?? 0
                totalPrice += Float(quantity) * price
            }
        }
        return totalPrice
    }
    
    
    func dateDayToString(dayFormat: DateFormatter.Style) -> String? {
        return dateToString(dayFormat: dayFormat, timeFormat: .none)
    }
    
    
    func dateTimeToString(timeFormat: DateFormatter.Style) -> String? {
        return dateToString(dayFormat: .none, timeFormat: timeFormat)
    }
    
    func dateToString(dayFormat: DateFormatter.Style, timeFormat: DateFormatter.Style) -> String? {
        guard let date = self.date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dayFormat
        dateFormatter.timeStyle = timeFormat
        return dateFormatter.string(from: date)
    }
}

extension Purchase: Mappable {
    
    func mapping(map: Map) {
        date <- (map[Constants.Purchase.DATE_KEY], CustomDateTransform())
        checkoutItems <- map[Constants.Purchase.PRODUCTS_KEY]
        total = calculateTotal()
    }
}
