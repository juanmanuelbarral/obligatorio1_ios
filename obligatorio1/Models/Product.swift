//
//  Product.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

enum Category: String {
    case Fruits = "Fruits"
    case Veggies = "Veggies"
    
    static let allCases = [Fruits, Veggies]
}

class Product {
    
    var id: Int
    var name: String
    var price: Float
    var category: Category
    var photoUrl: String
    
    
    init(id: Int, name: String, price: Float, photoUrl: String, category: Category) {
        self.id = id
        self.name = name
        self.price = price
        self.photoUrl = photoUrl
        self.category = category
    }
}
