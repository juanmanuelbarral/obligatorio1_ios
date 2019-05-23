//
//  Product.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Product {
    
    var id: Int?
    var name: String?
    var price: Float?
    var category: String?
    var photoUrl: String?
    
    
    init(id: Int, name: String, price: Float, photoUrl: String, category: String) {
        self.id = id
        self.name = name
        self.price = price
        self.photoUrl = photoUrl
        self.category = category
    }
    
    required init?(map: Map) {
        if map.JSON[Constants.Product.ID_KEY] == nil { return nil }
        if map.JSON[Constants.Product.NAME_KEY] == nil { return nil }
        if map.JSON[Constants.Product.PRICE_KEY] == nil { return nil }
        if map.JSON[Constants.Product.CATEGORY_KEY] == nil {
            self.category = Constants.Product.CATEGORY_DEFAULT_VALUE
        }
        if map.JSON[Constants.Product.PHOTO_URL_KEY] == nil {
            self.photoUrl = Constants.Product.PHOTO_URL_DEFAULT_VALUE2
        }
    }
}

extension Product: Mappable {
    func mapping(map: Map) {
        id <- map[Constants.Product.ID_KEY]
        name <- map[Constants.Product.NAME_KEY]
        price <- map[Constants.Product.PRICE_KEY]
        category <- map[Constants.Product.CATEGORY_KEY]
        photoUrl <- map[Constants.Product.PHOTO_URL_KEY]
    }
}
