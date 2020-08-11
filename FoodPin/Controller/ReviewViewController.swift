//
//  ReviewViewController.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/26.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    // 宣告 restaurant 變數來存放目前的餐廳
    var restaurant: RestaurantMO!
    
    
    // MARK: - Table View 生命週期
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        // 應用模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let scaleTransform = CGAffineTransform.init(scaleX: 50, y: 50)
        
        let moveTransform_0 = CGAffineTransform.init(translationX: 0, y: -2000)
        let moveTransform_1 = CGAffineTransform.init(translationX: 0, y: -1000)
        let moveTransform_3 = CGAffineTransform.init(translationX: 0, y: 1000)
        let moveTransform_4 = CGAffineTransform.init(translationX: 0, y: 2000)
        
        let moveScaleTransform_0 = scaleTransform.concatenating(moveTransform_0)
        let moveScaleTransform_1 = scaleTransform.concatenating(moveTransform_1)
        let moveScaleTransform_3 = scaleTransform.concatenating(moveTransform_3)
        let moveScaleTransform_4 = scaleTransform.concatenating(moveTransform_4)
        
        // 使按鈕隱藏並移至畫面外
        for rateButton in rateButtons {
            rateButton.alpha = 0
        }
        // 關閉按鈕動畫
        self.closeButton.alpha = 0
        self.closeButton.transform = scaleTransform
        
        self.rateButtons[0].transform = moveScaleTransform_0
        self.rateButtons[1].transform = moveScaleTransform_1
        self.rateButtons[2].transform = scaleTransform
        self.rateButtons[3].transform = moveScaleTransform_3
        self.rateButtons[4].transform = moveScaleTransform_4
    }

    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
            self.rateButtons[0].alpha = 1.0
            self.rateButtons[0].transform = .identity   // .identity 會重設按鈕至原來的位置
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
            self.rateButtons[1].alpha = 1.0
            self.rateButtons[1].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
            self.rateButtons[2].alpha = 1.0
            self.rateButtons[2].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
            self.rateButtons[3].alpha = 1.0
            self.rateButtons[3].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
            self.rateButtons[4].alpha = 1.0
            self.rateButtons[4].transform = .identity
        }, completion: nil)
        
        // 關閉按鈕的動畫
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
            self.closeButton.alpha = 1.0
            self.closeButton.transform = .identity
        }, completion: nil)
    
    }

}
