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
        searchImage.frame = CGRect(x: titleLabel!.frame.size.width / 2 + width / 2, y: 0, width: 20, height: 20)
        titleLabel?.addSubview(searchImage)
        
        var city = UserDefaults.standard.object(forKey: "city") as? String
        if city == nil {
            city = "定位"
        }
        self.leftBtn?.frame = CGRect(x: 10, y: 32, width: 50, height: 20)
        self.leftBtn?.setImage(UIImage.init(), for: UIControlState())
        self.leftBtn?.setTitle(city, for: UIControlState())
    }
    
    //初始化控件
    func loadSubViews() {
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - 49), style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.register(MainVCCell.self, forCellReuseIdentifier: "cell")
        tableHeadView = MainVCHeadView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110))
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
            self.leftBtn?.setTitle(city, for:UIControlState())
            
            //清除数据
            self.cellDataArr.removeAll()
            self.headDataArr.removeAll()
            
            //API获取 天气数据
            self.getWeatherData()
        }
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - API获取 天气数据
    func getWeatherData(){
        
        let city = UserDefaults.standard.object(forKey: "city") as? String
        
        guard city != nil else {
            let show = UIAlertView.init(title: "提示", message: "需要您的位置信息", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "定位")
            show.show()
            return
        }
        
        SVProgressHUD.show(withStatus: "加载中...")
        NetWorkManager.requestHeweather(city!, success: { (response) -> Void in
            
            let json = JSON.init(response!)
            let mainArray = json["HeWeather data service 3.0"]
            var i = 0
            for (_,dict):(String,JSON) in mainArray{
            
                i = i + 1
                guard i < 2 else {
                    break
                }
                guard dict["status"] == "ok" else {
                    SVProgressHUD.showError(withStatus: "暂无内容")
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
                SVProgressHUD.showError(withStatus: errorStr!)
        }
    }

    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellDataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MainVCCell
        cell!.cellModel = cellDataArr[indexPath.section]
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeadView = UIView.init()
        sectionHeadView.backgroundColor = UIColor.init(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        return sectionHeadView
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            let vc = LocationViewController.init()
            vc.navigationItem.title = "城市选择"
            vc.locationClosure = { (city) in
                self.leftBtn?.setTitle(city, for:UIControlState())
                
                self.cellDataArr.removeAll()
                self.headDataArr.removeAll()
                //API获取 天气数据
                self.getWeatherData()
                
               
            }
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true, completion: nil)
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
