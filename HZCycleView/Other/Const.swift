//
//  Const.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/11.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let scaleW = screenWidth/375.0
let scaleH = screenHeight/667.0

let baseColor = UIColor(red: 243.0 / 255.0, green: 34.0 / 255.0, blue: 0, alpha: 1)
let commonColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1)
let lineColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0  / 255.0, alpha: 1)
let blueColor = UIColor(red: 3.0 / 255.0, green: 115.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
let randomColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
//let isIPhoneX = UIScreen.main.bounds.size.equalTo(CGSize (width: 375, height: 812))
//let navigationBarHeight:CGFloat = isIPhoneX ? 88 : 64
//let bottomToolBarHeight:CGFloat = isIPhoneX ? 80 : 49

//适配Iphone_X XR XS XSMax
let Is_Iphone = (UI_USER_INTERFACE_IDIOM() == .phone)

let Is_Iphone_X_XS_XR_XSMAX = (Is_Iphone && screenHeight >= 812)

// 导航栏高度
let SafeAreaTopHeight  = Is_Iphone_X_XS_XR_XSMAX ? 88 : 64
let SafeAreaBottomHeight = Is_Iphone_X_XS_XR_XSMAX ? 34 : 0
// 状态栏高度
let STATUS_BAR_HEIGHT = Is_Iphone_X_XS_XR_XSMAX ? 44 : 20
// tabBar高度
let TabbarHeight = 49

/// 特定的
let cycleViewHeight = 200.0

