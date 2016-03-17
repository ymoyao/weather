//
//  DiaryDetailViewController.swift
//  Weathers
//
//  Created by SR on 16/3/16.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class DiaryDetailViewController: RootViewController,UITextViewDelegate {

    var textView:UITextView?
    var notepad_list_id:Int64?
    var model:NotepadModel?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载本地数据
        loadDBData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //监听键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTextHeight:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        //定制导航栏和按钮
        loadNavSubView()
        
        //加载子控件
        loadSubViews()
        
        
        frameSubViews()
        // Do any additional setup after loading the view.
    }
    
    
    func loadSubViews() {
        textView = UITextView.init()
        textView?.delegate = self
        textView?.returnKeyType = UIReturnKeyType.Done
        self.view.addSubview(textView!)
    }
    
    func frameSubViews() {
        textView?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view).offset(64)
            make.bottom.left.right.equalTo(self.view)
        })
    }
    
    //MARK: - 定制导航栏和按钮
    func loadNavSubView() {
        
        self.titleLabel?.text = self.navigationItem.title
        self.rightBtn?.hidden = false
        self.rightBtn?.frame = CGRectMake(Utils.screenWidth() - 60, 32, 50, 20)
        self.rightBtn?.setTitle("保存", forState: UIControlState.Normal)
        self.rightBtn?.setImage(UIImage.init(), forState: UIControlState.Normal)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    //MARK: - 点击保存
    override func rightBtnClick() {
        SVProgressHUD.showWithStatus("正在保存...")
        let model = NotepadModel()
        model.content = self.textView!.text
        model.notepad_list_id = notepad_list_id!
        let array = DatabaseManager.SharedInstance.selectTable("notepad_content", goalId: notepad_list_id)
        if array.count > 0 {
            if array[0].notepad_list_id == notepad_list_id {
                //更新数据库
                DatabaseManager.SharedInstance.upadateTable("notepad_content", goalId: notepad_list_id, value: model.content, star: nil)
            }
        }
        else{
            //插入数据库
            DatabaseManager.SharedInstance.insertTable("notepad_content", data: [model])
        }
        SVProgressHUD.showSuccessWithStatus("保存成功")
    }
    
    //MARM: - 加载本地数据
    func loadDBData() {
        model = DatabaseManager.SharedInstance.selectTable("notepad_content", goalId: notepad_list_id).last
        textView?.text = model?.content
    }
    
    //MARK: - 监听键盘弹出事件
    func changeTextHeight(not:NSNotification) {
        let valueStr = not.userInfo!["UIKeyboardFrameEndUserInfoKey"]
        let str = String(valueStr)
        let range = Range.init(start: str.startIndex.advancedBy(22), end: str.startIndex.advancedBy(25))
        let valueFloat = Float(str.substringWithRange(range))
        if valueFloat == Float(Utils.screenHeight())  {
            var frame = self.textView?.frame
            frame?.size.height = Utils.screenHeight() - 64
            self.textView?.frame = frame!
        }
        else{
            var frame = self.textView?.frame
            frame?.size.height = CGFloat.init(valueFloat! - 64)
            self.textView?.frame = frame!
        }
    }
    
    //MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
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
