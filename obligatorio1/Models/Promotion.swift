//
//  Promotion.swift
//  obligatorio1
//
//  Created by Manu on 25/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class Promotion {
    
    var name: String
    var description: String
    var photoUrl: String
    
    init(name: String, description: String, photoUrl: String) {
        self.name = name
        self.description = description
        self.photoUrl = photoUrl
    }
}
