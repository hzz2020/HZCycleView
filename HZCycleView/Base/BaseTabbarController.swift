//
//  BaseTabbarController.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/11.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

public enum HZTabBarStyle {
    case HZTabBarStyleDefault
    case HZTabBarStyleBlack
}

class BaseTabbarController: UITabBarController {
    
    var barStyle:HZTabBarStyle?
    var _tabBarHidden:Bool?
    var _tabBarView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = baseColor;
        
        customView();
    }
    
    private func customView() {
        createNavController(vc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        createNavController(vc: CatagoryViewController(), title: "分类", imageName: "tabbar_catagory")
        createNavController(vc: GirlViewController(), title: "美女", imageName: "tabbar_girl")
        createNavController(vc: ReadViewController(), title: "阅读", imageName: "tabbar_read")
        createNavController(vc: MineViewController(), title: "我的", imageName: "tabbar_mine")
    }
    
    private func createNavController (vc :UIViewController, title: String, imageName: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + ("_selected"))
        addChild(BaseNavigationController(rootViewController: vc))
    }
    

}
