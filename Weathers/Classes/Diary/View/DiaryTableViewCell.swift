//
//  DiaryTableViewCell.swift
//  Weathers
//
//  Created by SR on 16/3/9.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

@objc protocol DiaryTableViewCellDelegate : NSObjectProtocol {
    optional func diaryCellStarDidSelected(cell:DiaryTableViewCell, row:Int, btn:UIButton)
}

class DiaryTableViewCell: UITableViewCell {

    weak var delegate: DiaryTableViewCellDelegate?
    var row:Int?
    var cellModel:NotepadModel? {
        didSet{

            logoBtn?.selected = cellModel!.star
            contentLabel?.text = cellModel?.title
            subLabel?.text = cellModel?.date
        }
    }
    var logoBtn:UIButton?
    var contentLabel:UILabel?
    var subLabel:UILabel?
    var bottomView:UIView?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        loadSubViews()
    }
    
    func loadSubViews() {
        bottomView = UIView.init()
        bottomView?.backgroundColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        logoBtn = UIButton.init(type: UIButtonType.Custom)
        logoBtn?.addTarget(self, action: Selector("logoClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        logoBtn?.setImage(UIImage.init(named:"grayStar"), forState: UIControlState.Normal)
        logoBtn?.setImage(UIImage.init(named:"redStarSel"), forState: UIControlState.Selected)

        
        contentLabel = UILabel.init()
        contentLabel?.text = ""
        contentLabel?.textAlignment = NSTextAlignment.Center
        contentLabel?.textColor = UIColor.blackColor()
        contentLabel?.numberOfLines = 0
        contentLabel?.font = UIFont.boldSystemFontOfSize(17)
        
        subLabel = UILabel.init()
        subLabel?.text = ""
        subLabel?.textColor = UIColor.blackColor()
        subLabel?.textAlignment = NSTextAlignment.Right
        subLabel?.font = UIFont.systemFontOfSize(18)
        
        self.contentView.addSubview(bottomView!)
        self.contentView.addSubview(logoBtn!)
        self.contentView.addSubview(contentLabel!)
        self.contentView.addSubview(subLabel!)
        
        //        logoImageView?.backgroundColor = UIColor.greenColor()
        //        contentLabel?.backgroundColor = UIColor.yellowColor()
        //        subLabel?.backgroundColor = UIColor.purpleColor()
    }
    
    func logoClick(btn:UIButton) {
        btn.selected = !btn.selected
        cellModel?.star = btn.selected
        delegate?.diaryCellStarDidSelected!(self, row: row!,btn: btn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoBtn?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.width.equalTo(self.frame.size.height - 10 - 20)
        })
        
        subLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.top.equalTo(self.contentView).offset(10)
            make.width.equalTo(105)
        })
        
        contentLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(subLabel!.snp_left)
            make.left.equalTo(logoBtn!.snp_right)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-10)
        })
        
        bottomView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(10)
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
