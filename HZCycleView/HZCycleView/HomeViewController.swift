//
//  HomeViewController.swift
//  Learn-swift
//
//  Created by laolai on 2020/7/16.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, HomeTableViewCellDelegate, UISearchBarDelegate {
    
    var topView:UIView?
    var fileDatas:NSArray?
    var cycleDatas:NSArray?
    var cycleView:HZCycleView?
    
    let CellIdentifier = "HomeTableViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "首页";
        view.backgroundColor = UIColor.white
        
        buildSubViews()
        getFileDatas()
        getCycleDatas()
        // 开始网络状态监测
        // 由于可能多个地方需要知道网络状态，所以添加通知`kNetworkStatusNotification`即可
        // 在通知回调方法里面，判断`HN.networkStatus`即可
        HN.startMonitoring()
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
            self.cycleDatas = (JSONDeserializer<HomeTopModel>.deserializeModelArrayFrom(array: list)! as NSArray)
            
            let model:HomeTopModel = self.cycleDatas?.firstObject as! HomeTopModel
            print("测试\(String(describing: model.title))")
            self.cycleView = HZCycleView.init(frame: CGRect.init(x: 0, y: 300, width: kScreenWidth, height: 136))
            self.cycleView?.showData(array: self.cycleDatas!)
            self.cycleView?.autoAnimation(autoAnimation: true)
            self.view.addSubview(self.cycleView!)
        }.failed { (error) in
            // TODO...
            print(error)
        }
    }
    
    func buildSubViews() {
        let tableView = UITableView.init(frame: CGRect.zero, style:.plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { m in
            m.left.equalToSuperview()
            m.right.equalToSuperview()
            m.width.height.equalToSuperview()
        }
        
        topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigatioHeight));
        topView!.backgroundColor = UIColor.white
        
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.setImage(UIImage.init(named: "icon_add"), for: .normal)
        topView!.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { m in
            m.left.equalToSuperview()
            m.top.equalToSuperview().offset(kNavigatioHeight-44)
            m.width.height.equalTo(44)
        }
        
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setImage(UIImage.init(named: "icon_add"), for: .normal)
        topView!.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { m in
            m.centerY.equalTo(leftBtn)
            m.right.equalToSuperview()
            m.width.height.equalTo(44)
        }
        
        let searchBar = UISearchBar.init()
        searchBar.layer.cornerRadius = 15
        searchBar.clipsToBounds = true
        searchBar.backgroundImage = UIImage.init(color: UIColor.init(hexString: "f5f5f5")!, size: searchBar.bounds.size)
        searchBar.barTintColor = UIColor.init(hexString: "f5f5f5")!
        searchBar.placeholder = "搜索全部内容"
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.init(hexString: "f5f5f5")!
        }
        searchBar.setImage(Public.getImgView("icon_search_gray"), for: .search, state: .normal)
        searchBar.setImage(Public.getImgView("icon_close_gray"), for: .clear, state: .normal)
        searchBar.delegate = self;
        topView?.addSubview(searchBar)
        searchBar.snp.makeConstraints { m in
            m.centerY.equalTo(leftBtn)
            m.left.equalTo(leftBtn.snp.right).offset(0)
            m.right.equalTo(rightBtn.snp.left).offset(0)
            m.height.equalTo(30)
        }

    }
    
    func getFileDatas() {
        let filePath:String = Bundle.main.path(forResource: "homeData", ofType:"plist")!
        let fileDict:NSDictionary = NSDictionary(contentsOfFile:filePath)!
        let filelist1:NSArray = fileDict.object(forKey: "cell1") as! NSArray
        fileDatas = filelist1
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:HomeTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell
        if !(cell != nil) {
            cell = HomeTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HomeTableViewCell")
        }
        cell.datas = self.fileDatas
        cell.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
    
    func clickItem() {
        print(#function)
    }
    
    func clickDelBtn() {
        print(#function)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
//            cycleView = HZCycleView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 136))
//            cycleView!.showData(array: ["哈哈哈","嘿嘿嘿嘿","你好啊"])
//            cycleView!.autoAnimation(autoAnimation: true)
//            return cycleView
        }
        return topView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 136
        }
        return kNavigatioHeight
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
