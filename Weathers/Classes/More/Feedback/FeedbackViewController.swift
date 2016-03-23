//
//  FeedbackViewController.swift
//  Weathers
//
//  Created by SR on 16/3/18.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class FeedbackViewController: RootViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    var dataArray:[[String:String]]?
    var tableHeadView:FeedbackHeadView?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        loadNavSubViews()
    
        loadSubViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 导航栏
    func loadNavSubViews() {
        self.titleLabel?.text = self.navigationItem.title
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    //MARK: - 子视图
    func loadSubViews() {
        tableView = UITableView.init(frame: CGRectMake(0, 64, Utils.screenWidth(), Utils.screenHeight() - 64), style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView?.tableHeaderView = loadTableViewHeadView()
        tableView?.registerClass(FeedbackTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 加载本地数据
    func loadData() {
       let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        dataArray = [["key":"作者","content":"游辉"],["key":"当前版本","content":version],["key":"邮箱","content":"developer_yh@163.com"]]
    }
    
    //MARK: - 加载头部视图
    func loadTableViewHeadView() -> FeedbackHeadView {
        tableHeadView = FeedbackHeadView.init(frame: CGRectMake(0, 0, Utils.screenWidth(), 200)) //330
        return tableHeadView!
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FeedbackTableViewCell
        cell.dict = self.dataArray![indexPath.row]
        return cell
    }
    
 
//    override func leftBtnClick() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    

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
