//
//  HomeCell.swift
//  HZCycleView
//
//  Created by laolai on 2020/8/12.
//  Copyright © 2020 llh. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:HomeModel?
    
    var backView:UIView?
    var iconImageView:UIImageView?
    var titleLabel:UILabel?
    var nameLabel:UILabel?
    var timeLabel:UILabel?
    
    override init(style: HomeCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildUI()
        
        setUpviews()
    }
    
    
    func buildUI() {
        backView = UIView.init()
        backView?.backgroundColor = .white
        backView?.layer.cornerRadius = 4;
        backView?.layer.shadowOpacity = 1;
        backView?.layer.shadowRadius = 5
        backView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        backView?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.addSubview(backView!)
        backView?.snp.makeConstraints({ make in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
            make.height.equalTo(100)
        })
        
        iconImageView = UIImageView.init()
        iconImageView?.backgroundColor = .gray
        iconImageView?.contentMode = .scaleAspectFill
        iconImageView?.clipsToBounds = true
        backView!.addSubview(iconImageView!)
        iconImageView?.snp.makeConstraints({ make in
            make.top.left.equalTo(8)
            make.width.height.equalTo(84)
        })

        titleLabel = UILabel.init()
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleLabel?.textColor = .darkText
        titleLabel?.numberOfLines = 2
        backView!.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ make in
            make.top.equalTo(iconImageView!.snp.top)
            make.left.equalTo(iconImageView!.snp.right).offset(10)
            make.right.equalTo(-10)
        })
        
        timeLabel = UILabel.init()
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        timeLabel?.textColor = .darkGray
        backView!.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ make in
            make.bottom.equalTo(iconImageView!.snp.bottom)
            make.left.equalTo(titleLabel!.snp.left)
            make.height.equalTo(14)
        })
        
        nameLabel = UILabel.init()
        nameLabel?.font = UIFont.systemFont(ofSize: 14)
        nameLabel?.textColor = .darkGray
        backView!.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.bottom.equalTo(timeLabel!.snp.top).offset(-6)
            make.left.equalTo(titleLabel!.snp.left)
            make.height.equalTo(16)
        })
    }

    func setUpviews() {
        
        if self.model != nil {
            if (self.model?.images!.count)! > 0 {
                let url = URL(string: (self.model?.images?.firstObject)! as! String)
                print("image地址为：\(url?.absoluteString ?? "")")
                iconImageView?.kf.setImage(with: url)
            } else {
                let url = URL(string: (self.model?.url)!)
                iconImageView?.kf.setImage(with: url)
            }
            titleLabel?.text = self.model?.desc
            nameLabel?.text = "\(self.model?.author ?? "") * \(self.model?.type ?? "")"
            timeLabel?.text = self.model?.createdAt
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpviews()
    }

}
