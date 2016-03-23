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
import SVProgressHUD
import SwiftyJSON


class MainViewController: RootViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{

    var btn:UIButton?
    var tableView:UITableView?
    var tableHeadView:MainVCHeadView?
    var cellDataArr = [MainVCCellModel?]()
    var headDataArr =  [MainVCModel?]()
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
        
        self.titleLabel?.text = "天气"
        //计算菜单图片的位置
        let width = Utils.calWidthWithLabel(self.titleLabel!)
        let searchImage =  UIImageView.init(image: UIImage.init(named: "nav_search"))
        searchImage.frame = CGRectMake(titleLabel!.frame.size.width / 2 + width / 2, 0, 20, 20)
        titleLabel?.addSubview(searchImage)
        
        var city = NSUserDefaults.standardUserDefaults().objectForKey("city") as? String
        if city == nil {
            city = "定位"
        }
        self.leftBtn?.frame = CGRectMake(10, 32, 50, 20)
        self.leftBtn?.setImage(UIImage.init(), forState: UIControlState.Normal)
        self.leftBtn?.setTitle(city, forState: UIControlState.Normal)
    }
    
    //初始化控件
    func loadSubViews() {
        tableView = UITableView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 49), style: .Plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.registerClass(MainVCCell.self, forCellReuseIdentifier: "cell")
        tableHeadView = MainVCHeadView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 110))
        tableHeadView?.closure = { () in
            
            //清除数据
            self.cellDataArr.removeAll()
            
            self.headDataArr.removeAll()
            
            //API获取 天气数据
            self.getWeatherData()
        }
        tableView?.tableHeaderView = tableHeadView
        self.view.addSubview(tableView!)
    }
    
//    override func titleTapGes() {
//    
//        
//        
//    }
    
    //MARK: - 导航栏左边点击事件
    override func leftBtnClick() {
        print("定位点击")
        
        let vc = LocationViewController()
        vc.navigationItem.title = "城市选择"
        vc.locationClosure = { (city) in
            self.leftBtn?.setTitle(city, forState:UIControlState.Normal)
            
            //清除数据
            self.cellDataArr.removeAll()
            self.headDataArr.removeAll()
            
            //API获取 天气数据
            self.getWeatherData()
        }
        vc.modalTransitionStyle = .CoverVertical
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //MARK: - API获取 天气数据
    func getWeatherData(){
        
        let city = NSUserDefaults.standardUserDefaults().objectForKey("city") as? String
        
        guard city != nil else {
            let show = UIAlertView.init(title: "提示", message: "需要您的位置信息", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "定位")
            show.show()
            return
        }
        
        SVProgressHUD.showWithStatus("加载中...")
        NetWorkManager.requestHeweather(city!, success: { (response) -> Void in
            
            let json = JSON.init(response!)
            let mainArray = json["HeWeather data service 3.0"]
            var i = 0
            for (_,dict):(String,JSON) in mainArray{
            
                guard ++i < 2 else {
                    break
                }
                guard dict["status"] == "ok" else {
                    SVProgressHUD.showErrorWithStatus("暂无内容")
                    break
                }
                SVProgressHUD.dismiss()
                let nowDict = dict["now"]
                let aqiDict = dict["aqi"]
                let basicDict = dict["basic"]
                let suggestionDict = dict["suggestion"]
                let headModel = MainVCModel.init()
                headModel.code = nowDict["cond"]["code"].stringValue
                headModel.txt = nowDict["cond"]["txt"].stringValue
                headModel.tmp = nowDict["tmp"].stringValue
                headModel.dir = nowDict["wind"]["dir"].stringValue
                headModel.sc = nowDict["wind"]["sc"].stringValue
                headModel.vis = nowDict["vis"].stringValue
                headModel.qlty = aqiDict["city"]["qlty"].stringValue
                headModel.pm25 = aqiDict["city"]["pm25"].stringValue
                headModel.city = basicDict["city"].stringValue
                headModel.cnty = basicDict["cnty"].stringValue
                headModel.loc = basicDict["update"]["loc"].stringValue
                headModel.sportTxt = suggestionDict["sport"]["txt"].stringValue
                self.headDataArr.append(headModel)
                
                
                let daily_forecastArray = dict["daily_forecast"]
                for (_,dict):(String,JSON) in daily_forecastArray {
                    let cellModel = MainVCCellModel.init()
                    cellModel.date = dict["date"].stringValue
                    cellModel.code_d = dict["cond"]["code_d"].stringValue
                    cellModel.code_n = dict["cond"]["code_n"].stringValue
                    cellModel.txt_d = dict["cond"]["txt_d"].stringValue
                    cellModel.txt_n = dict["cond"]["txt_n"].stringValue
                    cellModel.max = dict["tmp"]["max"].stringValue
                    cellModel.min = dict["tmp"]["min"].stringValue
                    self.cellDataArr.append(cellModel)
                }
            }
            
            
            
            if self.headDataArr.count > 0{
                self.tableHeadView?.headModel = self.headDataArr[0]
            }
            else{
                //没找到就清除头部数据
                self.tableHeadView?.clearContent()
            }
            self.tableView?.reloadData()
        
             print("json = \(json)")
            }) { (errorStr) -> Void in
                SVProgressHUD.showErrorWithStatus(errorStr!)
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
        sectionHeadView.backgroundColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        return sectionHeadView
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let vc = LocationViewController.init()
            vc.navigationItem.title = "城市选择"
            vc.locationClosure = { (city) in
                self.leftBtn?.setTitle(city, forState:UIControlState.Normal)
                
                self.cellDataArr.removeAll()
                self.headDataArr.removeAll()
                //API获取 天气数据
                self.getWeatherData()
                
               
            }
            vc.modalTransitionStyle = .CoverVertical
            presentViewController(vc, animated: true, completion: nil)
        }
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
