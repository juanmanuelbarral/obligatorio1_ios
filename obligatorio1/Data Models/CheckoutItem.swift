//
//  CheckoutItem.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class CheckoutItem {
    
    var item: SupermarketItem
    private var units: Int
    
    init(item: SupermarketItem, units: Int) {
        self.item = item
        setUnits(units: units)
    }
    
//    According to what was said in class units are limited between 0 and 10
//    The setter controls these border issues
    func setUnits(units: Int) {
        if units<0 {
            self.units = 0
        } else if units>10 {
            self.units = 10
        } else {
            self.units = units
        }
    }
}
