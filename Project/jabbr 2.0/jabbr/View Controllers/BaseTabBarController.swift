//
//  BaseTabBarController.swift
//  jabbr
//
//  Created by Jimmy Yue on 9/20/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
