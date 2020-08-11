//
//  UIColor+Ext.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/19.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

// 擴展 UIColor 類別
extension UIColor {
    //建立初始化器
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        // self在初始化器區分 屬性名稱 與 參數
        self.init(red: redValue, green: greenValue, blue: blueValue,  alpha: 1.0)
    }
}


