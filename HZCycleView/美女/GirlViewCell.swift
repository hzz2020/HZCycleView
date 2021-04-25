//
//  GirlViewCell.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/12.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit
import Kingfisher

class GirlViewCell: UICollectionViewCell {
    
    var model:GirlModel?
    var imageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        imageView = UIImageView.init()
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        contentView.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.top.left.equalTo(3)
            make.right.bottom.equalTo(-3)
        })
        
        
    }
    
    func setUpViews() {
        if self.model != nil {
            let url = URL(string: (self.model?.url)!)
            imageView?.kf.setImage(with: url)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpViews()
    }
    
}
