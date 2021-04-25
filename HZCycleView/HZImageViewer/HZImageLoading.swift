//
//  HZImageLoading.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/14.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

class HZImageLoading: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progress:CGFloat = 0.0
    var loadLabel:UILabel?
    var progressLayer:CAShapeLayer?
    
    class func showInView(view: UIView) -> HZImageLoading  {
        let loadView = HZImageLoading.init(frame: view.bounds)
        view.addSubview(loadView)
        return loadView
    }
    
    @discardableResult class func showAlertInView(view: UIView, message: String) -> HZImageLoading {
        let loadView = HZImageLoading.init(frame: view.bounds, message: message)
        view.addSubview(loadView)
        return loadView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildLoadingView()
    }
    
    init(frame: CGRect, message: String) {
        super.init(frame: frame)
        
        buildAlertView(message: message)
    }
    
    func buildLoadingView() {
        let viewWidth:CGFloat = 35.0
        loadLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: viewWidth))
        loadLabel!.textAlignment = .center
        loadLabel!.textColor = .white
        loadLabel!.font = UIFont.systemFont(ofSize: 10)
        loadLabel!.center = center
        loadLabel!.text = "0%"
        addSubview(loadLabel!)
        
        let lineWidth:CGFloat = 3.0
        let centerX:CGFloat = viewWidth/2.0
        let centerY:CGFloat = viewWidth/2.0
        let radius:CGFloat = (viewWidth - lineWidth)/2.0  /// 半径
        /// 创建贝塞尔路径
        let path:UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: centerX, y: centerY), radius: radius, startAngle: CGFloat(.pi * (-0.5)), endAngle: CGFloat(.pi * 1.5), clockwise: true)
        //添加背景圆环
        let backLayer:CAShapeLayer = CAShapeLayer.init()
        backLayer.frame = loadLabel!.bounds
        backLayer.fillColor =  UIColor.clear.cgColor
        backLayer.strokeColor  = UIColor.green.cgColor
        backLayer.lineWidth = lineWidth
        backLayer.path = path.cgPath
        backLayer.strokeEnd = 1
        loadLabel!.layer.addSublayer(backLayer)
        //创建进度layer
        progressLayer = CAShapeLayer.init()
        progressLayer!.frame = loadLabel!.bounds
        progressLayer!.fillColor =  UIColor.clear.cgColor
        progressLayer!.strokeColor  = UIColor.white.cgColor
        progressLayer!.lineCap = CAShapeLayerLineCap.round
        progressLayer!.lineWidth = lineWidth
        progressLayer!.path = path.cgPath
        progressLayer!.strokeEnd = 0
        loadLabel!.layer.addSublayer(progressLayer!)
    }
    
    
    func buildAlertView(message: String) {
        let alertHeignt:CGFloat = 70.0
        let alertWidth:CGFloat = 120
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: alertWidth, height: alertHeignt))
        view.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
        view.center = center
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        addSubview(view)
        
        let effect = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = view.bounds
        view.addSubview(effectView)
        
        let label = UILabel.init(frame: effectView.bounds)
        label.text = message
        label.textColor = .red//[UIColor colorWithRed:68.0/255.0f green:68.0/255.0f blue:69.0/255.0f alpha:1];
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(label)
        
        let delayTime = DispatchTime(uptimeNanoseconds: 2)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.removeFromSuperview()
        }
    }
    
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    func setupViews() {
        self.progress = self.progress <= 0 ? 0 : self.progress
        self.progress = self.progress >= 1 ? 1 : self.progress
        
        self.loadLabel!.text = String.init(format: "%.2f", self.progress * 100.0)
        self.progressLayer!.strokeEnd = self.progress
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
}
