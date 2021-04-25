//
//  HomeModel.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/12.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit
import HandyJSON

class HomeModel: NSObject {
    @objc var _id : String?
    @objc var author : String?
    @objc var category : String?
    @objc var createdAt : String?
    @objc var desc : String?
    @objc var images : NSMutableArray?
    @objc var likeCounts : NSNumber?
    @objc var publishedAt : String?
    @objc var stars : NSNumber?
    @objc var title : String?
    @objc var type : String?
    @objc var url : String?
    @objc var views : NSNumber?
}


class HomeCatagoryModel: HandyJSON {
    var _id: String?
    var coverImageUrl : String?
    var desc: String?
    var title: String?
    var type: String?
    
    required init() {}
}
