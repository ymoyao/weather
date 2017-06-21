//
//  FeedbackTableViewCell.swift
//  Weathers
//
//  Created by SR on 16/3/18.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {

    
    var dict:[String:String]? {
        didSet{
            
            titleLabel?.text = dict!["key"]
            contentLabel?.text = dict!["content"]
            
            let frameTWidth = Utils.calWidthWithLabel(titleLabel!)
            var frameT = titleLabel?.frame
            frameT?.size.width = frameTWidth
            titleLabel?.frame = frameT!
            
     
            var frameC = contentLabel?.frame
            frameC?.origin.x = frameTWidth + 10
            frameC?.size.width = Utils.screenWidth() - frameTWidth - 20
            contentLabel?.frame = frameC!
        }
    }
    var titleLabel:UILabel?
    var contentLabel:UILabel?
    var lineView:UIView?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubViews() {
        
    
        titleLabel = Factory.customLabel(CGRect(x: 10, y: 0, width: 100, height: self.frame.size.height))
        titleLabel?.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(titleLabel!)
        
        contentLabel = Factory.customLabel(CGRect(x: Utils.screenWidth() - 100, y: 0, width: 100,  height: self.frame.size.height))
        contentLabel?.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(contentLabel!)
        
        lineView = UIView.init()
        lineView?.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(lineView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView?.frame = CGRect(x: 10, y: self.frame.size.height - 1, width: Utils.screenWidth() - 10, height: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
