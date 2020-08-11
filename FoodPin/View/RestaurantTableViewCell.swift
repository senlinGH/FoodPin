//
//  RestaurantTableViewCell.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/8.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit


class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tyoeLabel: UILabel!
    @IBOutlet var heartImageView: UIImageView!
    @IBOutlet var thumbnialImageView: UIImageView! {
        didSet {    // didSet 就是屬性觀察者, 在 didSet 區塊中, 每次設定屬性值會被呼叫
            thumbnialImageView.layer.cornerRadius = thumbnialImageView.bounds.width / 2
            thumbnialImageView.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
