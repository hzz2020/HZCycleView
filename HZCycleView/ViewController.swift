//
//  ViewController.swift
//  HZCycleView
//
//  Created by laolai on 2020/7/16.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit
import HandyJSON

class ViewController: UIViewController {

    var cycleView:HZCycleView?
    var backView:UIView?
    let viewHeight = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        buildSubViews()
        
        getCycleDatas()
        // 开始网络状态监测
        // 由于可能多个地方需要知道网络状态，所以添加通知`kNetworkStatusNotification`即可
        // 在通知回调方法里面，判断`HN.networkStatus`即可
        HN.startMonitoring()
    }
    
    func buildSubViews() {
        backView = UIView.init(frame: CGRect.init(x: 0, y: 300, width: Int(UIScreen.main.bounds.size.width), height: viewHeight))
        backView!.backgroundColor = UIColor.gray
        view.addSubview(backView!)
    }
        
    // get请求
    func getCycleDatas() {
        let url = "https://gank.io/api/v2/banners"
//        let p: [String : Any] = ["name": "demo", "age": 18]
        
        HN.GET(url: url, parameters: nil).success { (response) in
            // TODO...
            print(response)
            let dic:[String:Any] = response as! [String:Any]
            let list:[NSDictionary] = dic["data"] as! [NSDictionary]
            let cycleDatas = (JSONDeserializer<HZDataModel>.deserializeModelArrayFrom(array: list)! as NSArray)
            self.cycleView = HZCycleView.init(frame: CGRect.init(x: 0, y: 300, width: Int(UIScreen.main.bounds.size.width), height: self.viewHeight))
            self.cycleView!.showData(array:cycleDatas)
            self.cycleView!.autoAnimation(autoAnimation: true)
            self.view.addSubview(self.cycleView!)
            self.backView?.isHidden = true
        }.failed { (error) in
            // TODO...self.
            print(error)
        }
    }


}

