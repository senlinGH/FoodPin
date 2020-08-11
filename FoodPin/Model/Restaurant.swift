//
//  Restaurant.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/16.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

// 建立Restaurant類別
class Restaurant {
    var name: String
    var type: String
    var location: String
    var phone: String
    var description: String
    var image: String
    var isVisited: Bool
    var rating: String
    
    
    
    init(name: String, type: String, location: String, phone: String, description: String, image: String, isVisited: Bool, rating: String = "") {
        // 由於類別的屬性和初始化的參數相同，使用self來參照類別的屬性
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.image = image
        self.isVisited = isVisited
        self.rating = rating
    }
    
    // 便利初始化器，意思就是當呼叫這個類別沒輸入參數值的話，會以下方便利初始化的值定義
    convenience init() {
        self.init(name: "", type: "", location: "", phone: "", description: "", image: "", isVisited: false)
    }
}
