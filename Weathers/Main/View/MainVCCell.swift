//
//  MainVCCell.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit


class MainVCCell: UITableViewCell {

    
  

    var logoImageView:UIImageView?
    var contentLabel:UILabel?
    var subLabel:UILabel?
    
    
    var cellModel:MainVCModel? {
        didSet{

            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.redColor()
        loadSubViews()
    }
    
    func loadSubViews() {
        logoImageView = UIImageView.init()
        logoImageView?.image = UIImage.init(named: "sunshine")

        contentLabel = UILabel.init()
        contentLabel?.text = "-15℃"
        contentLabel?.textAlignment = NSTextAlignment.Center
        contentLabel?.textColor = UIColor.whiteColor()
        contentLabel?.font = UIFont.boldSystemFontOfSize(30)
        
        subLabel = UILabel.init()
        subLabel?.text = "wednesday"
        subLabel?.textColor = UIColor.whiteColor()
        subLabel?.textAlignment = NSTextAlignment.Right
        subLabel?.font = UIFont.systemFontOfSize(18)
        
        self.contentView.addSubview(logoImageView!)
        self.contentView.addSubview(contentLabel!)
        self.contentView.addSubview(subLabel!)
        
//        logoImageView?.backgroundColor = UIColor.greenColor()
//        contentLabel?.backgroundColor = UIColor.yellowColor()
//        subLabel?.backgroundColor = UIColor.purpleColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.width.equalTo(self.frame.size.height - 20)
        })
        
        subLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.bottom.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.width.equalTo(100)
        })
        
        contentLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(subLabel!.snp_left)
            make.center.equalTo(self.contentView)
            make.top.bottom.equalTo(self.contentView)
            make.width.lessThanOrEqualTo((subLabel!.frame.origin.x - self.center.x)*2)
        })
    }
    
  

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
