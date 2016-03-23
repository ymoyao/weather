//
//  FeedbackTableViewHeadView.swift
//  Weathers
//
//  Created by SR on 16/3/19.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SnapKit

class FeedbackHeadView: UIView {

    var logoImageView:UIImageView?
    var titleLabel:UILabel?
//    var logoView:UIWebView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
        
        frameSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubViews() {
        
//        let data = NSData.init(contentsOfFile: NSBundle.mainBundle().pathForResource("aboutLove", ofType: "gif")!)
//        logoView = UIWebView.init()
//        logoView?.loadData(data!, MIMEType: "image/gif", textEncodingName: "", baseURL: NSURL.init())
//        logoView?.userInteractionEnabled = false
//        self.addSubview(logoView!)
        
        logoImageView = UIImageView.init()
        logoImageView?.image = UIImage.init(named: "180")
        self.addSubview(logoImageView!)
        
        titleLabel = Factory.customLabel(nil)
        titleLabel?.text = "亲爱的伙伴们,如果你有新的想法和需求,请联系我哦~"
        titleLabel?.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel!)
    }
    
    func frameSubViews() {
    
//        logoView?.snp_makeConstraints(closure: { (make) -> Void in
//            make.top.left.right.equalTo(self)
//            make.height.equalTo(self).offset(-50)
//        })
        
        logoImageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(130, 130))
        })
        
        titleLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(logoImageView!.snp_bottomMargin).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-5)
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
