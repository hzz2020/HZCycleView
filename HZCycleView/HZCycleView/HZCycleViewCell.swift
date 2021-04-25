//
//  HZCycleViewCell.swift
//  Learn-swift
//
//  Created by 大辉郎 on 2020/7/15.
//  Copyright © 2020 LLHHZZ. All rights reserved.
//

import UIKit
import SnapKit

class HZCycleViewCell: UICollectionViewCell {
    
    
    var title:String?
    var textLabel:UILabel?
    var backImageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buildUI() {
        backImageView = UIImageView.init()
        backImageView?.contentMode = .scaleAspectFill
        backImageView?.clipsToBounds = true
        contentView.addSubview(backImageView!)
        
        backImageView?.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalToSuperview()
        })
        
        textLabel = UILabel.init()
        textLabel?.numberOfLines = 1
        textLabel?.textColor = UIColor.white
        textLabel?.textAlignment = NSTextAlignment.center
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(textLabel!)
        
        textLabel?.snp.makeConstraints({ make in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
        })
    }
    
    func show(title: String, imageName: String) {
        textLabel?.text = title
        
        let url = URL(string: imageName)
        backImageView?.kf.setImage(with: url)
    }
    
    
}
