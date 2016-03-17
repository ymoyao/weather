//
//  DiaryViewController.swift
//  Weathers
//
//  Created by SR on 16/3/9.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import KLCPopup

class DiaryViewController: RootViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DiaryTableViewCellDelegate {

    var tableView:UITableView?
    var dataArray = [NotepadModel]()
    var popView:KLCPopup?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载数据库数据
        loadDBData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //定制导航栏和按钮
        loadNavSubViews()
        
        //加载子控件
        loadSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 加载子控件
    func loadSubViews() {
        tableView = UITableView.init(frame: CGRectMake(0, 64, Utils.screenWidth(), Utils.screenHeight() - 64), style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView?.registerClass(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryCell")
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 定制导航栏和按钮
    func loadNavSubViews() {
        
        self.titleLabel?.text = "记事本"
        self.leftBtn?.frame = CGRectMake(10, 32, 50, 20)
        self.leftBtn?.setTitle("编辑", forState: UIControlState.Normal)
        self.leftBtn?.setTitle("删除", forState: UIControlState.Selected)
        self.leftBtn?.setImage(UIImage.init(), forState: UIControlState.Normal)
        self.rightBtn?.hidden = false
    }

    
    //MARK: - 编辑
    override func leftBtnClick() {
        self.leftBtn!.selected = !(self.leftBtn!.selected)
        self.tableView!.setEditing(self.leftBtn!.selected, animated: true)
    }
    
    //MARK: - 添加note
    override func rightBtnClick() {
        
        let contentView = UIView.init(frame: CGRectMake(20, 0, Utils.screenWidth() - 40, 100))
        contentView.backgroundColor = UIColor.blackColor()
        contentView.alpha = 0.5
        contentView.layer.cornerRadius = 9
        
        let titleLabel = UILabel.init(frame: CGRectMake(0, 10, contentView.frame.size.width, 20))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "标题"
        contentView.addSubview(titleLabel)
        
        let textField = UITextField.init(frame: CGRectMake(20, 40, contentView.frame.size.width - 20*2, 30))
        textField.returnKeyType = UIReturnKeyType.Done
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "请输入标题"
        textField.delegate = self
        textField.becomeFirstResponder()
        contentView.addSubview(textField)
        
        popView = KLCPopup.init(contentView: contentView, showType: KLCPopupShowType.BounceIn, dismissType: KLCPopupDismissType.BounceOut, maskType: KLCPopupMaskType.Clear, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popView?.showAtCenter(CGPointMake(Utils.screenWidth() / 2, 120), inView: self.view)

    }
    
    func loadDBData() {
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            self.dataArray = DatabaseManager.SharedInstance.selectTable("notepad_list", goalId: nil)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
            })
        }
       
    }
    
    
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //取消第一响应
        textField.resignFirstResponder()
        //取消弹出框
        popView?.dismiss(false)
        
        //数据库
        let model = NotepadModel()
        model.title = textField.text!
        model.date =  Utils.dateStr(NSDate.init(), dateFormat: "YYYY-MM-dd")
        DatabaseManager.SharedInstance.insertTable("notepad_list", data: [model])


        //跳转
        let vc = DiaryDetailViewController()
        let array = DatabaseManager.SharedInstance.selectTable("notepad_list", goalId: nil)
        vc.notepad_list_id = array.last?.id
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = "新建"
        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }
    
    //MARK: - DiaryTableViewCellDelegate
    func diaryCellStarDidSelected(cell: DiaryTableViewCell, row: Int, btn: UIButton) {
        let model = dataArray[row]
        DatabaseManager.SharedInstance.upadateTable("notepad_list", goalId: model.id, value: nil, star: model.star)
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as! DiaryTableViewCell
        cell.cellModel = dataArray[indexPath.row]
        cell.delegate = self
        cell.row = indexPath.row
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DiaryDetailViewController()
        vc.notepad_list_id = dataArray[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = "新建"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let model = dataArray[indexPath.row]
            DatabaseManager.SharedInstance.deleteTable("notepad_list", goalId: [model.id])
            DatabaseManager.SharedInstance.deleteTable("notepad_content", goalId: [model.id])
            dataArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: indexPath.row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
