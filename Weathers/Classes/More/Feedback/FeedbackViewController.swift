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
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK: - 子视图
    func loadSubViews() {
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: Utils.screenWidth(), height: Utils.screenHeight() - 64), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.tableHeaderView = loadTableViewHeadView()
        tableView?.register(FeedbackTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 加载本地数据
    func loadData() {
       let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        dataArray = [["key":"作者","content":"游辉"],["key":"当前版本","content":version],["key":"邮箱","content":"developer_yh@163.com"]]
    }
    
    //MARK: - 加载头部视图
    func loadTableViewHeadView() -> FeedbackHeadView {
        tableHeadView = FeedbackHeadView.init(frame: CGRect(x: 0, y: 0, width: Utils.screenWidth(), height: 200)) //330
        return tableHeadView!
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FeedbackTableViewCell
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
