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
    
    private func generateUrlRequest(url: String, method: HTTPMethod) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    func getProducts(onCompletion: @escaping ([Product]?, Error?) -> Void) {
        let url = Constants.API.BASE_URL + Constants.API.GET_PRODUCTS
        Alamofire.request(url).validate().responseArray { (response: DataResponse<[Product]>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value, nil)
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    func getPromotions(onCompletion: @escaping ([Promotion]?, Error?) -> Void) {
        let url = Constants.API.BASE_URL + Constants.API.GET_PROMOTIONS
        Alamofire.request(url).responseArray { (response: DataResponse<[Promotion]>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value, nil)
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    func getPurchases(onCompletion: @escaping ([Purchase]?, Error?) -> Void) {
        let url = Constants.API.BASE_URL + Constants.API.GET_PURCHASES
        Alamofire.request(url).responseArray { (response: DataResponse<[Purchase]>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value, nil)
            case .failure(let error):
                onCompletion(nil, error)
            }
            
        }
    }
    
    func postCheckout() -> Bool {
        let url = Constants.API.BASE_URL + Constants.API.POST_CHECKOUT
        guard let urlRequest = generateUrlRequest(url: url, method: HTTPMethod.post) else { return false }
        // TODO: post with Alamofire
        return false
    }
}
