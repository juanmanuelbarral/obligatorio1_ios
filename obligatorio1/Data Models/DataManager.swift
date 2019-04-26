//
//  DataManager.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class DataManager {
    
//    Property for the singleton
    static let sharedInstance = DataManager()
    
    private var supermarketItems: [SupermarketItem]
    private var bannerItems: [BannerItem]
    
    private init() {
        
    }
    
    func getBannerItems() -> [BannerItem] {
        <#function body#>
    }
    
    func getSupermarketItems() -> [SupermarketItem] {
        <#function body#>
    }
}
