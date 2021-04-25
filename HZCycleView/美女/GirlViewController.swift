//
//  GirlViewController.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/12.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

class GirlViewController: BaseViewController {

    var isBigView:Bool?
    var collectionView: UICollectionView?
    var dataSources:NSMutableArray?
    let kCellIdentifier = "GirlViewCell"
    var pageIndex:NSInteger?
    let pageCount = 10
    
    let header = MJRefreshNormalHeader()     // 顶部刷新
    let footer = MJRefreshAutoNormalFooter() // 底部刷新
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        buildUI()
    }
    
    func buildUI() {
        
        isBigView = false
        /// 导航栏处理
        let rightButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(named: "navbar_change_list"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightClicked(button:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        
        /// 内容
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: Double(screenWidth/2.0), height: Double(screenWidth/2.0+30))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = .white
        collectionView?.register(GirlViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView!.showsVerticalScrollIndicator = false
        view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints({ make in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(Int(screenHeight)-SafeAreaTopHeight-SafeAreaBottomHeight-TabbarHeight)
        })
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        collectionView!.mj_header = header
        collectionView?.mj_header?.beginRefreshing()
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        collectionView!.mj_footer = footer
    }
    
    func loadNetData() {
        
        let HomeGirlTypeUrl = "\(baseUrl)\(baseGirlType)\(basePage)\(pageIndex ?? 1)\(baseCount)\(pageCount)"
        print("打印" + HomeGirlTypeUrl)
        HN.GET(url: HomeGirlTypeUrl, parameters: nil).success { (response) in
            print(response)
            let dic:[String:Any] = response as! [String:Any]
            let list:[NSDictionary] = dic["data"] as! [NSDictionary]
            if self.pageIndex == 1 {
                self.dataSources = GirlModel.mj_objectArray(withKeyValuesArray: list)
            } else {
                self.dataSources?.addObjects(from: GirlModel.mj_objectArray(withKeyValuesArray: list) as! [Any])
            }
            
            if list.count >= self.pageCount {
                self.collectionView?.mj_footer?.isHidden = false
            } else {
                self.collectionView?.mj_footer?.isHidden = true
                self.collectionView?.mj_footer?.endRefreshingWithNoMoreData()
            }
             
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.collectionView?.mj_header?.endRefreshing()
                self.collectionView?.mj_footer?.endRefreshing()
            }
        }.failed { (error) in
            print(error)
        }
        
    }
    
    /// 切换显示样式
    @objc func rightClicked(button:UIButton) {
        
        let layout = UICollectionViewFlowLayout.init()
        
        if isBigView! {
            isBigView = false
            button.setImage(UIImage.init(named: "navbar_change_list"), for: .normal)
            layout.itemSize = CGSize.init(width: Double(screenWidth/2.0), height: Double(screenWidth/2.0+30))
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
        } else {
            isBigView = true
            button.setImage(UIImage.init(named: "navbar_change_block"), for: .normal)
            layout.itemSize = CGSize.init(width: Double(screenWidth), height: Double(screenWidth+50))
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
        }
        collectionView?.collectionViewLayout = layout
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    /// 下拉刷新
    @objc func headerRefresh() {
        pageIndex = 1
        loadNetData()
    }
    
    /// 上滑加载更多
    @objc func footerRefresh() {
        pageIndex! += 1
        loadNetData()
    }
    
}


extension GirlViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! GirlViewCell
        let model:GirlModel = dataSources![indexPath.row] as! GirlModel
        cell.model = model
        return cell;
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:GirlModel = dataSources![indexPath.row] as! GirlModel
        print(model.title as Any)
        let view = collectionView .cellForItem(at: indexPath)
        let hzimageViewer = HZImageViewer.init(frame: UIScreen.main.bounds)
        hzimageViewer.showNetImages(images: (dataSources?.copy())! as! NSArray, index: indexPath.row, imageContainer: view!)
    }
    
}
