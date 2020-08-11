//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Lin Yi Sen on 2020/7/10.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel: UILabel! {
        didSet {    // didSet屬性觀察器，在新的值被設置之後立即呼叫
            headingLabel.numberOfLines = 0  // 設定支援多行顯示
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentImageView: UIImageView!
    
    var index = 0   // index變數是用來儲存目前頁面的索引值
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    
    
    
    
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 這三行的意思是初始化這些標籤和圖片
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
    

    
}
