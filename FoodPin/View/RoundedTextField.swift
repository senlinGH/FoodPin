//
//  RoundedTextField.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/30.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // 回傳的繪製矩形是針對文字欄位的文字
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // 回傳的繪製矩形是針對文字欄位的佔位符文字
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // 回傳的矩形是用於顯示可編輯的文字
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
