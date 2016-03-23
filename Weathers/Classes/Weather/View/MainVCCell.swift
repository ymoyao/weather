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
            
            logoImageView?.image = UIImage.init(named: (cellModel?.code_d)!
            )
            contentLabel?.text = (cellModel?.min)! + "/" + (cellModel?.max)! + "℃"
            subLabel?.text = cellModel?.date
        }
    }
    
    var logoImageView:UIImageView?
    var contentLabel:UILabel?
    var subLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        loadSubViews()
    }
    
    func loadSubViews() {
        logoImageView = UIImageView.init()

        contentLabel = UILabel.init()
        contentLabel?.text = ""
        contentLabel?.textAlignment = NSTextAlignment.Center
        contentLabel?.textColor = UIColor.init(red: 53/255.0, green: 110/255.0, blue: 154/255.0, alpha: 1.0)
        contentLabel?.font = UIFont.boldSystemFontOfSize(30)
        
        subLabel = UILabel.init()
        subLabel?.text = ""
        subLabel?.textColor = UIColor.init(red: 53/255.0, green: 110/255.0, blue: 154/255.0, alpha: 1.0)
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
            make.width.equalTo(105)
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
