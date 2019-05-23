//
//  Promotion.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Promotion {
    
    var name: String?
    var description: String?
    var photoUrl: String?
    
    init(name: String, description: String, photoUrl: String) {
        self.name = name
        self.description = description
        self.photoUrl = photoUrl
    }
    
    required init?(map: Map) {
        if map.JSON[Constants.Promotion.NAME_KEY] == nil { return nil }
        if map.JSON[Constants.Promotion.DESCRIPTION_KEY] == nil {
            self.description = ""
        }
        if map.JSON[Constants.Promotion.PHOTO_URL_KEY] == nil {
            self.photoUrl = Constants.Promotion.PHOTO_URL_DEFAULT_VALUE
        }
    }
}


extension Promotion: Mappable {
    
    func mapping(map: Map) {
        name <- map[Constants.Promotion.NAME_KEY]
        description <- map[Constants.Promotion.DESCRIPTION_KEY]
        photoUrl <- map[Constants.Promotion.PHOTO_URL_KEY]
    }
}
