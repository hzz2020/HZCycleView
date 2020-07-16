//
//  HZCycleView.swift
//  Learn-swift
//
//  Created by 大辉郎 on 2020/7/15.
//  Copyright © 2020 LLHHZZ. All rights reserved.
//

import UIKit

class HZCycleView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var datas:NSArray?
    var autoPage:Bool?
    
    var collectionView:UICollectionView?
    var pageControl:UIPageControl?
    var timer:Timer?
    var titles:NSMutableArray?
    
    let controlHeight = 35
    let scrollInterval = 3.0
    let cellIdentifier = "HZCycleViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView!.isPagingEnabled = true;
        collectionView!.backgroundColor = UIColor.clear
        collectionView?.register(HZCycleViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView!.showsHorizontalScrollIndicator = false;
        addSubview(collectionView!)
        
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: Int(self.bounds.size.height)-controlHeight, width: Int(UIScreen.main.bounds.width), height: controlHeight))
        pageControl?.pageIndicatorTintColor = UIColor.lightGray
        pageControl?.currentPageIndicatorTintColor = UIColor.black
        addSubview(pageControl!);
        
        timer = Timer.scheduledTimer(timeInterval: scrollInterval, target: self, selector: #selector(showNext), userInfo: nil, repeats: true)
        timer!.fireDate = NSDate.distantFuture
        
        autoPage = false
    }
    
    func showData(array: NSArray) {
        datas = array
        titles = NSMutableArray.init(array: array)
        titles?.add(array.firstObject as Any)
        titles?.insert(array.lastObject as Any, at: 0)
        collectionView?.setContentOffset(CGPoint.init(x: (collectionView?.bounds.size.width)!, y: 0), animated: true)
        pageControl?.numberOfPages = array.count;
    }
    
    func autoAnimation(autoAnimation: Bool) {
        autoPage = autoAnimation
        let fireDate = autoAnimation ? (NSDate (timeIntervalSinceNow:scrollInterval) as Date) : (NSDate.distantFuture as Date)
        timer!.fireDate = fireDate;
    }
    
    // MARK: Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HZCycleViewCell
        let model:HZDataModel = titles![indexPath.row] as! HZDataModel
        cell.show(title: model.title!, imageName: model.image!)
        return cell;
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
