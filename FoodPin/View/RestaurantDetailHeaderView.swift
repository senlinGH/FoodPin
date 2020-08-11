//
//  RestaurantDetailHeaderView.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/17.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0     // 標籤設定多行顯示
        }
    }
    
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            // 設定圓角標籤
            typeLabel.layer.cornerRadius = 5.0  // layer物件的圓角半徑屬性設定為5
            typeLabel.layer.masksToBounds = true    // 開啟masksToBounds屬性
        }
    }
    
    @IBOutlet var heartImageView: UIImageView! {
        didSet {
            // 以.alwaysTemplate來呼叫withRenderingMode方法，這張圖片會作為模板來載入
            heartImageView.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
            // 然後再使用tintColor屬性邊更它的顏色
            heartImageView.tintColor = .white
        }
    }
    
    @IBOutlet var ratingImageView: UIImageView!

}
