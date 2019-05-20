//
//  Constants.swift
//  obligatorio1
//
//  Created by Manu on 18/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

struct Constants {
    
    // API
    struct API {
        static let BASE_URL = "https://us-central1-ucu-ios-api.cloudfunctions.net"
        static let GET_PRODUCTS = "/products"
        static let GET_PROMOTIONS = "/promoted"
        static let POST_CHECKOUT = "/checkout"
        static let GET_PURCHASES = "/purchases"
    }
    
    // Authentication
    struct Authentication {
        static let TOKEN_PREFIX = "Bearer "
    }
    
    // CheckoutItem
    struct CheckoutItem {
        static let MIN_QUANTITY = 0
        static let MAX_QUANTITY = 10
        
        static let PRODUCT_KEY = "product"
        static let QUANTITY_KEY = "quantity"
    }
    
    // Product
    struct Product {
        static let ID_KEY = "id"
        static let NAME_KEY = "name"
        static let PRICE_KEY = "price"
        static let CATEGORY_KEY = "category"
        static let PHOTO_URL_KEY = "photoUrl"
        
        static let CATEGORY_DEFAULT_VALUE = "other"
    }
    
    // Promotion
    struct Promotion {
        static let NAME_KEY = "name"
        static let DESCRIPTION_KEY = "description"
        static let PHOTO_URL_KEY = "photoUrl"
    }
    
    // Purchase
    struct Purchase {
        static let DATE_KEY = "date"
        static let PRODUCTS_KEY = "products"
    }
    
}
