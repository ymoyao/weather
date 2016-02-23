//
//  MainVCHeadView.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SnapKit

class MainVCHeadView: UIView {

    var tempLable:UILabel?
    var tempIntervalLabel:UILabel?
    var airLabel:UILabel?
    var weekLabel:UILabel?
    var locationProvince:UILabel?
    var locationCity:UILabel?
    var addCity:UIButton?
    var mainImageView:UIImageView?
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 250/255.0, green: 116/255.0, blue: 45/255.0, alpha: 1.0)
        
        loadSubView()
    }
    
    func loadSubView() {
    
        tempLable = UILabel.init()
        tempLable?.text = "5℃"
        tempLable?.textColor = UIColor.whiteColor()
        tempLable?.font = UIFont.systemFontOfSize(20.0)
        self.addSubview(tempLable!)
        
        tempIntervalLabel = UILabel.init()
        tempIntervalLabel?.text = "15/2℃"
        tempIntervalLabel?.textColor = UIColor.redColor()
        tempIntervalLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(tempIntervalLabel!)
        
        airLabel = UILabel.init()
        airLabel?.text = "clear"
        airLabel?.textColor = UIColor.whiteColor()
        airLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(airLabel!)
        
        weekLabel = UILabel.init()
        weekLabel?.textColor = UIColor.redColor()
        weekLabel?.text = "Monday"
        weekLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(weekLabel!)
        
        locationProvince = UILabel.init()
        locationProvince?.text = "上海"
        locationProvince?.textAlignment = NSTextAlignment.Right
        locationProvince?.textColor = UIColor.redColor()
        locationProvince?.font = UIFont.systemFontOfSize(17)
        self.addSubview(locationProvince!)
        
        locationCity = UILabel.init()
        locationCity?.text = "上海"
        locationCity?.textAlignment = NSTextAlignment.Right
        locationCity?.textColor = UIColor.redColor()
        locationCity?.font = UIFont.systemFontOfSize(15)
        self.addSubview(locationCity!)
        
        addCity = UIButton.init(type: UIButtonType.Custom)
        addCity?.setTitle("加", forState: UIControlState.Normal)
        addCity?.addTarget(self, action: Selector("btnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addCity!)
        
        mainImageView = UIImageView.init()
        mainImageView?.image = UIImage.init(named: "sunshine")
        self.addSubview(mainImageView!)
        
//        tempLable?.backgroundColor = UIColor.greenColor()
//        tempIntervalLabel?.backgroundColor = UIColor.redColor()
//        airLabel?.backgroundColor = UIColor.greenColor()
//        weekLabel?.backgroundColor = UIColor.redColor()
//        locationCity?.backgroundColor = UIColor.redColor()
//        locationProvince?.backgroundColor = UIColor.greenColor()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tempLable?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        
        tempIntervalLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(tempLable!.snp_bottom)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        })
        
        airLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(tempIntervalLabel!.snp_bottom)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        })
        
        weekLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-5)
            make.width.equalTo(70)
            make.height.equalTo(20)
        })
        
        locationProvince?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        })
        
        locationCity?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(locationProvince!.snp_bottom)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        })
        
        addCity?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
            make.size.equalTo(CGSizeMake(30, 30))
        })
        
        mainImageView?.snp_makeConstraints(closure: { (make) -> Void in
            let image =   UIImage.init(named: "sunshine")
            let width = image?.size.width
            let height = image?.size.height

            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(width!, height!))
            make.left.greaterThanOrEqualTo(tempLable!.snp_right)
            make.right.lessThanOrEqualTo(locationProvince!.snp_left)
        })
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
