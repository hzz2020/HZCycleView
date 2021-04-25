//
//  HZImageViewer.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/14.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

class HZImageViewer: UIView {
    //工具栏
//    XLImageViewerTooBar *toolBar;
    let cellId:String = "HZImageViewerCell"
    let lineSpacing = 10
    var collectionView:UICollectionView?  // 滚动的ScrollView
    var imageContainer:UIView?  //图片容器
    var startIndex:NSInteger?   // 第一次加载的位置
    var currentIndex:NSInteger? // 当前滚动位置
    var anchorFrame:CGRect?  //开始加载时的图片位置
    var imageUrls:NSArray?  //图片地址
    var showNetImages:Bool? //是否显示网络图片
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buildUI() {
        //设置ImageViewer属性
        frame = UIScreen.main.bounds
        
        //初始化CollectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(lineSpacing))
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: layout)
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView!.isPagingEnabled = true;
        collectionView!.register(HZImageViewerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.showsHorizontalScrollIndicator = false;
        addSubview(collectionView!)
        
        startIndex = 0
        currentIndex = 0
//        _toolBar = [[XLImageViewerTooBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - ToolBarHeight, self.bounds.size.width, ToolBarHeight)];
//        __weak typeof(self)weekSelf = self;
//        [_toolBar addSaveBlock:^{
//            [weekSelf saveImage];
//        }];
//        [self addSubview:_toolBar];
    }
    
    func showNetImages(images:NSArray, index:NSInteger, imageContainer: UIView) {
        showNetImages = true
        showImages(images: images, index: index, container: imageContainer)
    }
    
    func showLocalImages(images:NSArray, index:NSInteger, imageContainer: UIView) {
        showNetImages = false
        showImages(images: images, index: index, container: imageContainer)
    }
    
    func showImages(images: NSArray, index: NSInteger, container: UIView) {
        //设置图片容器
        imageContainer = container;
        //设置数据源
        imageUrls = images;
        //设置起始位置
        startIndex = index;
        /// 初始化锚点
        anchorFrame = imageContainer?.convert(imageContainer!.bounds, to: self)
        /// 更新显示
//        _toolBar.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_imageUrls.count];
//        [_toolBar show];
        /// 刷新CollectionView
        collectionView?.reloadData()
        /// 滚动到指定位置
        collectionView?.scrollToItem(at: NSIndexPath.init(row: index, section: 0) as IndexPath, at: .left, animated: false)
        /// 找到指定Cell执行放大动画
        collectionView?.performBatchUpdates(nil, completion: { (finished) in
            let item = self.collectionView?.cellForItem(at: NSIndexPath.init(row: index, section: 0) as IndexPath) as! HZImageViewerCell
            item.showEnlargeAnimation()
            //添加到屏幕上
            if let window = UIApplication.shared.windows.first(where: { (wd) -> Bool in
                if wd.isKeyWindow {
                    return true
                } else {
                    return false
                }
            }){
                window.addSubview(self)
            }
        })
    }
    
}

extension HZImageViewer: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HZImageViewerCell
        //设置属性
        cell.showNetImage = showNetImages
        cell.isStart = indexPath.row == startIndex
        cell.collectionView = collectionView
        cell.anchorFrame = anchorFrame
        let model:GirlModel = imageUrls![indexPath.row] as! GirlModel
        cell.setImageUrl(url: model.url!)
        //添加回调
        cell.addHideBlockStart(start: {
            print("hideBlock")
//            [weekSelf.toolBar hide];
        }, finish: {
            print("finishBlock")
            self.removeFromSuperview()
        }, cancle: {
            print("cancleBlock")
//            [weekSelf.toolBar show];
        })
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width);
//        toolBar.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_imageUrls.count];
    }
    
}
