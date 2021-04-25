//
//  HomeViewController.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/11.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit
import HandyJSON

class HomeViewController: BaseViewController {
    
    var tableView:UITableView?
    var cycleView:HZCycleView?
    var dataSources:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        buildSubViews()
        
        loadNetData()
    }
    
    func buildSubViews() {
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        tableView?.showsVerticalScrollIndicator = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView!.register(HomeCell.self, forCellReuseIdentifier:"HomeCell")
        view.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ make in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(Int(screenHeight)-SafeAreaTopHeight-SafeAreaBottomHeight-TabbarHeight)
        })
        /// 轮播图
        cycleView = HZCycleView.init();
        cycleView!.backgroundColor = .white
        tableView?.tableHeaderView = cycleView
        cycleView?.snp.makeConstraints({ make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(cycleViewHeight)
        })
        tableView?.tableHeaderView?.layoutIfNeeded()
        tableView?.tableHeaderView = cycleView
    }
        
    // get请求
    func loadNetData() {
        
        HN.GET(url: HomeHotGanHuoUrl, parameters: nil).success { (response) in
            print(response)
            let dic:[String:Any] = response as! [String:Any]
            let list:[NSDictionary] = dic["data"] as! [NSDictionary]
            self.dataSources = HomeModel.mj_objectArray(withKeyValuesArray: list)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }.failed { (error) in
            print(error)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kCellWithIdentifier = "HomeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellWithIdentifier, for:indexPath) as! HomeCell
        cell.selectionStyle = .none
        cell.model = self.dataSources![indexPath.row] as? HomeModel
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:HomeModel = self.dataSources![indexPath.row] as! HomeModel
        print(model.type as Any)
        
    }
}
