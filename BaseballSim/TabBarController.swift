//
//  TabBarController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/20/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for item in self.tabBar.items! as [UITabBarItem]
        {
            if let image = item.image
            {
                item.image = image.imageWithColor(tintColor: UIColor.black).withRenderingMode(.alwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
