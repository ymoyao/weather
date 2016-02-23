//
//  MainViewController.swift
//  天气
//
//  Created by SR on 16/1/27.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import MBProgressHUD
import SVProgressHUD


class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var btn:UIButton?
    var tableView:UITableView?
    var tableHeadView:MainVCHeadView?
    var cellDataArr = [MainVCCellModel?]()
    var headDataArr =  [MainVCModel?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "天气"
        
        //定制导航栏按钮
        customLeftBarButtonItem()
        
        //API获取 天气数据
        getWeatherData()
 
        //初始化控件
        loadSubViews()
        // Do any additional setup after loading the view.
    }

    //MARK: - 定制导航栏按钮
    func customLeftBarButtonItem() {
        btn = UIButton.init(type: UIButtonType.Custom)
        btn?.frame = CGRectMake(0, 0, 50, 40)
        btn?.setTitleColor(UIColor.init(red: 231/255.0, green: 68/255.0, blue: 60/255.0, alpha: 1.0), forState: UIControlState.Normal)
        btn?.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn?.setTitle("定位", forState: UIControlState.Normal)
        btn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn?.addTarget(self, action: Selector("btnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn!)
    }
    
    //初始化控件
    func loadSubViews() {
        tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height), style: .Plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.registerClass(MainVCCell.self, forCellReuseIdentifier: "cell")
        tableHeadView = MainVCHeadView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 110))
        tableView?.tableHeaderView = tableHeadView
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 导航栏左边点击事件
    func btnClick() {
        print("定位点击")
        
        let vc = LocationViewController()
        vc.titleView.text = "城市选择"
        vc.locationClosure = { (city) in
            self.btn?.setTitle(city, forState:UIControlState.Normal)
        }
        vc.modalTransitionStyle = .CoverVertical
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //MARK: - API获取 天气数据
    func getWeatherData(){
        NetWorkManager.requestWeather("f30df66d4e10", city: "上海", province: "上海", success:
            {(response) -> Void in
            
                let dict = response! as NSDictionary
                if (dict.objectForKey("retCode")!.isEqualToString("200")) {
                
                    let dataArr = dict.objectForKey("result")
                    print(dataArr)
                    
                    for  var i = 0; i < dataArr?.count ; i++ {
                        let dic  = dataArr![i]
                        let headModel = MainVCModel.init()
                        headModel.week = dic.objectForKey("week") as! String
                        headModel.temp = dic.objectForKey("temperature") as! String
                        
                        let arr = dic.objectForKey("future")
                        for var j = 0; j < arr?.count; j++ {
                            let subDic = arr![j]
                            let cellModel = MainVCCellModel.init()
                            cellModel.date = subDic.objectForKey("date") as! String
                            cellModel.dayTime = subDic.objectForKey("dayTime") as! String
                            cellModel.temperature = subDic.objectForKey("temperature") as! String
                            cellModel.week = subDic.objectForKey("week") as! String
                            cellModel.wind = subDic.objectForKey("wind") as! String
                            cellModel.night = subDic.objectForKey("night") as! String
                            self.cellDataArr.append(cellModel)
                        }
                        self.headDataArr.append(headModel)
                    }
                    self.tableView?.reloadData()
                }
                else{
                    SVProgressHUD.showErrorWithStatus(dict.objectForKey("msg") as! String, maskType: SVProgressHUDMaskType.None)
                }
                
            })
            {(error) -> Void in
                SVProgressHUD.showErrorWithStatus(error, maskType: SVProgressHUDMaskType.None)
        }

    }
    
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellDataArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? MainVCCell
        cell!.cellModel = cellDataArr[indexPath.section]
        return cell!
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeadView = UIView.init()
        sectionHeadView.backgroundColor = UIColor.init(red: 77/255.0, green: 66/255.0, blue: 77/255.0, alpha: 1.0)
        return sectionHeadView
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
