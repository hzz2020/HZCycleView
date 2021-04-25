//
//  HZImageViewerCell.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/14.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

//无参无返回值
typealias funcBlock = () -> () //或者 () -> Void

class HZImageViewerCell: UICollectionViewCell {
    
    let maxZoomScale:CGFloat = 2.5;
    let minZoomScale:CGFloat = 1.0;
    let minPanLength:CGFloat = 100.0;  /// 最小拖拽返回相应距离
    
    var showNetImage:Bool?
    var anchorFrame:CGRect?
    var isStart:Bool?
    var imageUrl:String?
    
    var collectionView:UICollectionView?
    var scrollView:UIScrollView?
    var imageView:UIImageView?
    var loadView:HZImageLoading?
    
    //返回方法
    var startHideBlock:funcBlock?
    var finishHideBlock:funcBlock?
    var cancleHideBlock:funcBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        scrollView = UIScrollView.init(frame: self.bounds)
        scrollView?.delegate = self
        scrollView?.maximumZoomScale = CGFloat(maxZoomScale)
        scrollView?.minimumZoomScale = CGFloat(minZoomScale)
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        scrollView?.panGestureRecognizer.addTarget(self, action: #selector(scrollViewPanMethod(pan:)))
        scrollView?.isUserInteractionEnabled = true
        contentView.addSubview(scrollView!)
        
        imageView = UIImageView.init(frame: scrollView!.bounds)
        imageView!.layer.masksToBounds = true
        imageView?.isUserInteractionEnabled = true
        imageView?.contentMode = .scaleAspectFit
        scrollView?.addSubview(imageView!)
        
        //添加双击方法
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(enlargeImageView))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        //添加单击方法
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(showShrinkDownAnimation))
        addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
        
        //添加加载动画
        loadView = HZImageLoading.showInView(view: self)
        loadView!.hide()
    }
    
    
    @objc func scrollViewPanMethod(pan: UIPanGestureRecognizer) {
        if (scrollView!.zoomScale != 1.0) {return;}
        if (scrollView!.contentOffset.y > 0) {
            cancleHideBlock!();
            return;
        }
        //拖拽结束后判断位置
        if (pan.state == .ended) {
            if (abs(scrollView!.contentOffset.y) < minPanLength) {
                cancleHideBlock!();
                UIView.animate(withDuration: 0.35) {
                    self.scrollView!.contentInset = .zero
                }
            } else {
                UIView.animate(withDuration: 0.35, animations: {
                    //设置移除动画
                    var frame = self.imageView!.frame
                    frame.origin.y = self.scrollView!.bounds.size.height
                    self.imageView!.frame = frame;
                    self.collectionView!.backgroundColor = UIColor.init(white: 0, alpha: 0)
                }) { (finish) in
                    //先通知上层返回
                    self.finishHideBlock!();
                    //重置状态
                    self.imageView!.frame = self.imageViewFrame()!
                    self.scrollView!.contentInset = .zero
                }
            }
        }else{
            /// 拖拽过程中逐渐改变透明度
            scrollView!.contentInset = UIEdgeInsets(top: -scrollView!.contentOffset.y, left: 0, bottom: 0, right: 0);
            let alpha:CGFloat = 1 - abs(scrollView!.contentOffset.y/(scrollView!.bounds.size.height));
            collectionView!.backgroundColor = UIColor.init(white: 0, alpha: alpha)
            startHideBlock!();
        }
        
    }
    
    /// 双击 放大/缩小
    @objc func enlargeImageView() {
        //已经放大后 双击还原 未放大则双击放大
        let zoomScale = scrollView?.zoomScale != CGFloat(minZoomScale) ? minZoomScale : maxZoomScale;
        scrollView?.setZoomScale(CGFloat(zoomScale), animated: true)
    }
    
    func addHideBlockStart(start: @escaping funcBlock, finish: @escaping funcBlock, cancle: @escaping funcBlock) {
        startHideBlock = start
        finishHideBlock = finish
        cancleHideBlock = cancle
    }
    
    func setImageUrl(url: String) {
        scrollView!.zoomScale = minZoomScale;
        imageUrl = url
        //显示本地图片
        if (!showNetImage!) {
            imageView!.image = UIImage.init(contentsOfFile: url)
            setImageViewFrame()
            loadView?.hide()
            return;
        }
        //显示网络图片
        let netUrl = URL(string: url)
        imageView?.kf.setImage(with: netUrl)
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loading show];
//                _loading.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
//            });
//        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            [self setImageViewFrame];
//            //隐藏加载
//            [_loading hide];
//        }];
    }
    
    ///
    func showEnlargeAnimation() {
        //如果还没加载完成网络图片则不显示动画
        imageView!.frame = anchorFrame!;
        collectionView!.backgroundColor = UIColor.init(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.35, animations: {
            self.collectionView!.backgroundColor = UIColor.init(white: 0, alpha: 1)
            self.imageView!.frame = self.imageViewFrame()!
        }) { (finished) in
            if (!(self.imageView!.image != nil)) {
                self.loadView!.show()
            }
        }
    }
    
    @objc func showShrinkDownAnimation() {
        startHideBlock!()
        //如果还没加载完成网络图片则不显示动画
        if ((imageView!.image) != nil) {
            let startRect:CGRect = CGRect.init(x: -scrollView!.contentOffset.x + imageView!.frame.origin.x, y: -scrollView!.contentOffset.y + imageView!.frame.origin.y, width: imageView!.frame.size.width, height: imageView!.frame.size.height)
            imageView!.frame = startRect
            contentView.addSubview(imageView!)
        }
        //设置CollectionView透明度
        collectionView!.backgroundColor = UIColor.init(white: 0, alpha: 1)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.collectionView!.backgroundColor = UIColor.init(white: 0, alpha: 0)
            if (self.isStart! && (self.imageView!.image != nil)) {
                self.imageView!.frame = self.anchorFrame!
            } else{
                self.alpha = 0
            }
        }) { (finished) in
            //通知回调
            self.finishHideBlock!();
            self.imageView!.frame = self.imageViewFrame()!
            self.alpha = 1;
            self.scrollView!.zoomScale = self.minZoomScale;
            self.scrollView!.addSubview(self.imageView!)
            self.scrollView?.setContentOffset(.zero, animated: false)
        }
    }
    
    func saveImage() {
        if (!(imageView!.image != nil)) {return;}
        UIImageWriteToSavedPhotosAlbum(imageView!.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            HZImageLoading.showAlertInView(view: self, message: "图片存储失败")
            return
        }
        HZImageLoading.showAlertInView(view: self, message: "图片存储成功")
    }
}

extension HZImageViewerCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageFrame()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (abs(scrollView.contentOffset.y) < minPanLength) {
            let alpha:CGFloat = 1 - abs(scrollView.contentOffset.y/(scrollView.bounds.size.height))
            collectionView!.backgroundColor = UIColor.init(white: 0, alpha: alpha)
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        if scale != 1 {
            return
        }
        let imageBounds:CGRect = imageViewFrame()!
        
        let height = imageBounds.size.height > scrollView.bounds.size.height ? imageBounds.size.height : scrollView.bounds.size.height + 1
        scrollView.contentSize = CGSize.init(width: (imageView?.bounds.size.width)!, height: height)
    }
    
    func updateImageFrame() {
        var imageFrame:CGRect  = imageView!.frame;
        
        if (imageFrame.size.width < bounds.size.width) {
            imageFrame.origin.x = (bounds.size.width - imageFrame.size.width)/2.0;
        }else{
            imageFrame.origin.x = 0;
        }
        
        if (imageFrame.size.height < bounds.size.height) {
            imageFrame.origin.y = (bounds.size.height - imageFrame.size.height)/2.0;
        }else{
            imageFrame.origin.y = 0;
        }
        
        if (!imageView!.frame.equalTo(imageFrame)){
            imageView!.frame = imageFrame;
        }
    }
    
    func imageViewFrame() -> CGRect? {
        if !(imageView!.image != nil) {
            return scrollView?.bounds
        }
        let image:UIImage = imageView!.image!
        let width:CGFloat = bounds.size.width
        let height:CGFloat = width * image.size.height/image.size.width
        let y:CGFloat = height < bounds.size.height ? (bounds.size.height - height)/2.0 : 0
        return CGRect.init(x: 0, y: y, width: width, height: height)
    }
    
    func setImageViewFrame () {
        if (!(imageView!.image != nil)) {return;}
        /// 这只imageview的图片和范围
        imageView!.frame = imageViewFrame()!
        /// 设置ScrollView的滚动范围
        let imageBounds:CGRect = imageViewFrame()!
        
        let height = imageBounds.size.height > scrollView!.bounds.size.height ? imageBounds.size.height : scrollView!.bounds.size.height + 1;
        scrollView!.contentSize = CGSize.init(width: (imageView!.bounds.size.width), height: height)
    }


}
