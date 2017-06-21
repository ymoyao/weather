//
//  MainVCHeadView.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SnapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias MainVCHeadViewClosure = () -> Void

class MainVCHeadView: UIView {

    var tempLable:UILabel?                  //温度
    var tempIntervalLabel:UILabel?          //可见度
    var airLabel:UILabel?                   //空气质量/风力
    var weekLabel:UILabel?                  //日期/星期
    var locationProvince:UILabel?           //国家
    var locationCity:UILabel?               //城市
    var addCity:UIButton?                   //刷新按钮
    var weatherDescribeLabel:UILabel?       //天气描述
    var mainImageView:UIImageView?          //天气图片
    var closure:MainVCHeadViewClosure?
    
    
    //MARK: - 赋值
    var headModel:MainVCModel? {
        didSet{
            tempLable?.text = (headModel?.tmp)! + "℃"
            tempIntervalLabel?.text = "可见度: " + (headModel?.vis)! + "km"
            if headModel?.qlty != "" {
                airLabel?.text = "空气质量: " + (headModel?.qlty)!
            }
            else{
                airLabel?.text = "风向: " + (headModel?.dir)! + "\n" + "风力: " + (headModel?.sc)! + "级"
            }
            mainImageView?.image = UIImage.init(named: (headModel?.code)!)
            if headModel?.pm25 != "" {
                weatherDescribeLabel?.text = (headModel?.txt)! + "/PM2.5|" + (headModel?.pm25)!
            }
            else{
                weatherDescribeLabel?.text = headModel?.txt
            }
            
            locationCity?.text = headModel?.city
            locationProvince?.text = headModel?.cnty
        
            if headModel?.loc.lengthOfBytes(using: String.Encoding.utf8) > 10 {
                let index = headModel?.loc.characters.index((headModel?.loc.startIndex)!, offsetBy: 10)
                weekLabel?.text = headModel?.loc.substring(to: index!)
            }
        }
    }
    
    //清除内容
    func clearContent() {
        tempLable?.text = ""
        tempIntervalLabel?.text = ""
        airLabel?.text = ""
        mainImageView?.image = UIImage.init()
        weatherDescribeLabel?.text = ""
        locationCity?.text = ""
        locationProvince?.text = ""
        weekLabel?.text = ""
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.init(red: 250/255.0, green: 116/255.0, blue: 45/255.0, alpha: 1.0)
        self.backgroundColor = UIColor.init(red: 128/255.0, green: 192/255.0, blue: 49/255.0, alpha: 1.0)
        
        loadSubView()
    }
    
    func loadSubView() {
    
        tempLable = UILabel.init()
        tempLable?.textColor = UIColor.white
        tempLable?.font = UIFont.systemFont(ofSize: 20.0)
        self.addSubview(tempLable!)
        
        tempIntervalLabel = UILabel.init()
        tempIntervalLabel?.textColor = UIColor.white
        tempIntervalLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(tempIntervalLabel!)
        
        airLabel = UILabel.init()
        airLabel?.numberOfLines = 2
        airLabel?.textColor = UIColor.white
        airLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(airLabel!)
        
        weekLabel = UILabel.init()
        weekLabel?.textColor = UIColor.white
        weekLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(weekLabel!)
        
        locationProvince = UILabel.init()
        locationProvince?.textAlignment = NSTextAlignment.right
        locationProvince?.textColor = UIColor.white
        locationProvince?.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(locationProvince!)
        
        locationCity = UILabel.init()
        locationCity?.textAlignment = NSTextAlignment.right
        locationCity?.textColor = UIColor.white
        locationCity?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(locationCity!)
        
        addCity = UIButton.init(type: UIButtonType.custom)
        addCity?.setImage(UIImage.init(named: "refresh"), for: UIControlState())
        addCity?.addTarget(self, action: #selector(MainVCHeadView.btnClick), for: UIControlEvents.touchUpInside)
        self.addSubview(addCity!)
        
        weatherDescribeLabel = UILabel.init()
        weatherDescribeLabel?.textAlignment = NSTextAlignment.center
        weatherDescribeLabel?.numberOfLines = 2
        weatherDescribeLabel?.textColor = UIColor.white
        weatherDescribeLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(weatherDescribeLabel!)

        
        mainImageView = UIImageView.init()
        self.addSubview(mainImageView!)
        
    }
    
    //MARK: - 刷新
    func btnClick() {
        closure!()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainImageView?.snp_makeConstraints({ (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp_top)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        })
        
        tempLable?.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(mainImageView!.snp_left)
            make.height.equalTo(20)
        }
        
        tempIntervalLabel?.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(tempLable!.snp_bottom)
            make.left.equalTo(self).offset(10)
             make.right.equalTo(mainImageView!.snp_left)
            make.height.equalTo(20)
        })
        
        airLabel?.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(tempIntervalLabel!.snp_bottom)
            make.left.equalTo(self).offset(10)
             make.right.equalTo(mainImageView!.snp_left)
            make.height.equalTo(40)
        })
        
        weekLabel?.snp_makeConstraints({ (make) -> Void in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-5)
             make.right.equalTo(mainImageView!.snp_left)
            make.height.equalTo(20)
        })
        
        locationProvince?.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(mainImageView!.snp_right)
            make.height.equalTo(20)
        })
        
        locationCity?.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(locationProvince!.snp_bottom)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(mainImageView!.snp_right)
            make.height.equalTo(20)
        })
        
        addCity?.snp_makeConstraints({ (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        })
        
        weatherDescribeLabel?.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(mainImageView!.snp_bottom)
            make.bottom.equalTo(self)
            make.width.equalTo(150)
            make.centerX.equalTo(self)
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
