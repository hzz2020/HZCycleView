//
//  HZCycleView.swift
//  Learn-swift
//
//  Created by 大辉郎 on 2020/7/15.
//  Copyright © 2020 LLHHZZ. All rights reserved.
//

import UIKit
import HandyJSON

class HZCycleView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var datas:NSArray?
    var autoPage:Bool?
    
    var collectionView:UICollectionView?
    var pageControl:UIPageControl?
    var timer:Timer?
    var titles:NSMutableArray?
    
    let controlHeight = 20
    let scrollInterval = 3.0
    let cellIdentifier = "HZCycleViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
        loadNetData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: Double(screenWidth), height: cycleViewHeight)
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView!.isPagingEnabled = true;
        collectionView!.backgroundColor = UIColor.clear
        collectionView?.register(HZCycleViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView!.showsHorizontalScrollIndicator = false;
        addSubview(collectionView!)
        collectionView?.snp.makeConstraints({ make in
            make.top.left.right.bottom.equalToSuperview()
        })
        
        pageControl = UIPageControl.init(frame: CGRect.zero)
        pageControl?.pageIndicatorTintColor = UIColor.gray
        pageControl?.currentPageIndicatorTintColor = UIColor.red
        addSubview(pageControl!);
        
        pageControl?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(controlHeight)
        })
        
//        timer = Timer.scheduledTimer(timeInterval: scrollInterval, target: self, selector: #selector(showNext), userInfo: nil, repeats: true)
//        timer!.fireDate = NSDate.distantFuture
        
        autoPage = false
    }
    
    func loadNetData() {
        print(HomeBannerUrl)
        HN.GET(url: HomeBannerUrl, parameters: nil).success { (response) in
            print(response)
            let dic:[String:Any] = response as! [String:Any]
            let list:[NSDictionary] = dic["data"] as! [NSDictionary]
            let cycleDatas = (JSONDeserializer<HZCycleModel>.deserializeModelArrayFrom(array: list)! as NSArray)
            self.showData(array:cycleDatas)
            self.autoAnimation(autoAnimation: true)
        }.failed { (error) in
            print(error)
        }
    }
    
    func showData(array: NSArray) {
        datas = array
        titles = NSMutableArray.init(array: array)
        titles?.add(array.firstObject as Any)
        titles?.insert(array.lastObject as Any, at: 0)
        collectionView?.setContentOffset(CGPoint.init(x: (collectionView?.bounds.size.width)!, y: 0), animated: true)
        pageControl?.numberOfPages = array.count
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func autoAnimation(autoAnimation: Bool) {
        autoPage = autoAnimation
        
        timer?.invalidate()
        timer = nil
        
        if autoAnimation {
            timer = Timer.scheduledTimer(timeInterval: scrollInterval, target: self, selector: #selector(showNext), userInfo: nil, repeats: true)
            let fireDate = autoAnimation ? (NSDate (timeIntervalSinceNow:scrollInterval) as Date) : (NSDate.distantFuture as Date)
            timer!.fireDate = fireDate;
        }

    }
    
    // MARK: Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HZCycleViewCell
        let model:HZCycleModel = titles![indexPath.row] as! HZCycleModel
        cell.show(title: model.title!, imageName: model.image!)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:HZCycleModel = titles![indexPath.row] as! HZCycleModel
        print(model.title as Any)
    }
    
    //手动拖拽结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        cycleScroll()
        //拖拽动作后间隔3s继续轮播
        if autoPage! {
            timer?.fireDate = NSDate (timeIntervalSinceNow: scrollInterval) as Date
        }
    }
    
    //自动轮播结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cycleScroll()
    }

    //循环显示
    func cycleScroll() {
        let page = Int((collectionView!.contentOffset.x/collectionView!.bounds.size.width)) as Int;
        
        if page == 0 {//滚动到左边
            collectionView!.contentOffset = CGPoint.init(x: Int((collectionView!.bounds.size.width)) * (titles!.count - 2), y: 0)
            pageControl!.currentPage = titles!.count - 2;
        } else if page == (titles!.count - 1) {//滚动到右边
            collectionView!.contentOffset = CGPoint.init(x: (collectionView?.bounds.size.width)!, y: 0)
            pageControl!.currentPage = 0;
        } else {
            pageControl!.currentPage = Int(page - 1);
        }
    }
    
    @objc func showNext() {
        //手指拖拽是禁止自动轮播
        if collectionView!.isDragging {
            return
        }
        let targetX =  collectionView!.contentOffset.x + collectionView!.bounds.size.width;
        collectionView?.setContentOffset(CGPoint.init(x: targetX, y: 0), animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
