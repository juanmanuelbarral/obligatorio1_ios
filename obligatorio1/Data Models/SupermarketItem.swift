//
//  SupermarketItem.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

enum Category: String {
    case Fruits = "Fruits"
    case Veggies = "Veggies"
}

class SupermarketItem {
    
    var name: String
    var price: Int
    var imageLogo: String
    var imageItem: String
    var category: Category
    
    init(name: String, price: Int, imageLogo: String, imageItem: String, category: Category) {
        self.name = name
        self.price = price
        self.imageLogo = imageLogo
        self.imageItem = imageItem
        self.category = category
    }
    
    func getPriceString() -> String {
        return "$\(price)"
    }
}
