//
//  ApiManager.swift
//  obligatorio1
//
//  Created by Manu on 19/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiManager {
    
    // Propoerty for the Singleton
    static let sharedInstance = ApiManager()
    
    private init() {}
    
    func getProducts() -> [Product]? {
        var products: [Product]? = nil
        let url = Constants.API.BASE_URL + Constants.API.GET_PRODUCTS
        Alamofire.request(url).responseArray { (response: DataResponse<[Product]>) in
            products = response.result.value
        }
        return products
    }
    
    func getPromotions() -> [Promotion]? {
        var promotions: [Promotion]? = nil
        let url = Constants.API.BASE_URL + Constants.API.GET_PROMOTIONS
        Alamofire.request(url).responseArray { (response: DataResponse<[Promotion]>) in
            promotions = response.result.value
        }
        return promotions
    }
    
    func getPurchases() -> [Purchase]? {
        var purchases: [Purchase]? = nil
        let url = Constants.API.BASE_URL + Constants.API.GET_PURCHASES
        Alamofire.request(url).responseArray { (response: DataResponse<[Purchase]>) in
            purchases = response.result.value
        }
        return purchases
    }
    
    func postCheckout() -> Bool {
        let url = Constants.API.BASE_URL + Constants.API.POST_CHECKOUT
        // TODO: post with Alamofire
        return false
    }
}
