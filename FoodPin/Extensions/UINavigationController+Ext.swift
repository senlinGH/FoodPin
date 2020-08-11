//
//  UINavigationController+Ext.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/22.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
