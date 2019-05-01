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
    
    var item: SupermarketItem
    private var units: Int = 0
    
    init(item: SupermarketItem, units: Int) {
        self.item = item
        setUnits(units: units)
    }
    
//    According to what was said in class units are limited between 0 and 10
//    The setter controls these border issues
    func setUnits(units: Int) {
        if units<MIN_UNITS {
            self.units = MIN_UNITS
        } else if units>MAX_UNITS {
            self.units = MAX_UNITS
        } else {
            self.units = units
        }
    }
    
    func getUnits() -> Int {
        return units
    }
}
