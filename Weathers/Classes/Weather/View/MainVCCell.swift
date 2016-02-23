//
//  MainVCCell.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit


class MainVCCell: UITableViewCell {

    var cellModel:MainVCCellModel? {
        didSet{
            
            logoImageView?.sd_setImageWithURL(NSURL.init(string: cellModel!.weatherImage), placeholderImage: UIImage.init(named: "sunshine"))
            contentLabel?.text = cellModel?.temperature
            subLabel?.text = cellModel?.week
        }
    }
    
    var logoImageView:UIImageView?
    var contentLabel:UILabel?
    var subLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.redColor()
        loadSubViews()
    }
    
    func loadSubViews() {
        logoImageView = UIImageView.init()

        contentLabel = UILabel.init()
        contentLabel?.text = "-15℃"
        contentLabel?.textAlignment = NSTextAlignment.Right
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
            make.width.equalTo(80)
        })
        
        contentLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(subLabel!.snp_left)
            make.left.equalTo(logoImageView!.snp_right)
            make.top.bottom.equalTo(self.contentView)
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
