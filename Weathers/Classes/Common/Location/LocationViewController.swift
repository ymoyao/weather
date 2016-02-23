//
//  LocationViewController.swift
//  Weather
//
//  Created by SR on 16/1/31.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import CoreLocation
import SQLite

typealias LocationClosure = (string:String) -> Void

class LocationViewController: UIViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate {

    var locationClosure:LocationClosure?
    
    var titleView:UILabel! = UILabel()
    var locationManager:CLLocationManager?
    var tableView:UITableView?
    var dataArray = [Array<String>]()
    var gpsCityName:String! = "正在定位..."
    let alephArray = ["GPS定位到的城市","A","B","C","D","E","F","G","H","J","k","L","M","N","P","Q","R","S","T","W","X","Y","Z"] //i o u v没有
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //定制vc的导航栏
        initVcNav()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        //初始化数据
        initCityData()
        
        //初始化子控件
        initSubViews()
        
        //初始化定位控制器
        initLocationManager()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 定制vc的导航栏
    func initVcNav() {
        let navView = UIView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64))
        navView.backgroundColor = UIColor.init(colorLiteralRed: 18/255.0, green: 85/255.0, blue: 137/255.0, alpha: 1.0)
        self.view.addSubview(navView)
        
        //返回按钮
        let backBtn = UIButton.init(type: UIButtonType.Custom)
        backBtn.addTarget(self, action: Selector("btnClick"), forControlEvents:UIControlEvents.TouchUpInside)
        backBtn.setImage(UIImage.init(named: "btn_close"), forState: UIControlState.Normal)
        backBtn.frame = CGRectMake(10, 30, 24, 24)
        navView.addSubview(backBtn)
        
        
        //标题
        let backBtnMaxX = backBtn.frame.size.width + backBtn.frame.origin.x
        titleView = UILabel.init(frame: CGRectMake(backBtnMaxX, 30, UIScreen.mainScreen().bounds.width - backBtnMaxX * 2, 24))
        titleView.textColor = UIColor.whiteColor()
        titleView.textAlignment = NSTextAlignment.Center
        navView.addSubview(titleView)

    }
    
    //MARK: - 初始化子控件
    func initSubViews() {
        tableView = UITableView.init(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        tableView?.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "locationHead")
        self.view.addSubview(tableView!)
    }
    
    //MARK: - 初始化定位控制器
    func initLocationManager() {
        locationManager = CLLocationManager()
        
        //避免如 9.2.1这样无法直接转为 float的bug
        let versionStr = UIDevice.currentDevice().systemVersion
        let versionArr = versionStr.componentsSeparatedByString(".")
        var versionFormate = 0
        for var i = 0; i < versionArr.count; i++ {
            let str = versionArr[i]
            if str != "." {
                versionFormate += (Int(powf(10.0,Float(versionArr.count - i))) * Int(str)!)
            }
        }
        
        if versionFormate >= 800 {
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if versionFormate >= 900 {
            locationManager!.allowsBackgroundLocationUpdates = true
        }
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func initCityData() {
        print(NSHomeDirectory())
        
        //字段
        let name = Expression<String?>("name")
        let aleph = Expression<String?>("aleph")
        
        let path = NSBundle.mainBundle().pathForResource("city", ofType: "sqlite3")
        let db = try! Connection(path!, readonly: true)
        let city = Table("city")
        
        var lastCityAleph:String! = ""
        var array = [String]()
        
        //添加首组数据
        dataArray.append([gpsCityName])
        
        //遍历
        for cityRow in try! db.prepare(city.order(aleph)) {
            
            let cityName = cityRow[name]!
            let cityAleph = cityRow[aleph]!
            
            if (lastCityAleph != cityAleph && lastCityAleph != "") || cityName == "中卫市"{
                if cityName == "中卫市" {
                    array.append(cityName)
                }
                dataArray.append(array)
                array.removeAll()
            }
            else{
                array.append(cityName)
            }
            
            lastCityAleph = cityAleph
            
            //插入
            //            let stmt = try! dbN.prepare("INSERT INTO city (name,aleph) VALUES (?,?)")
            //            try! stmt.run(cityName,firstName)
        }
    }
    
    
    //MARK: - 返回上级
    func btnClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MAKR: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //位置
        let location = locations.first
        
        //地理编码器
        let geoLocation = CLGeocoder.init()
        
        geoLocation.reverseGeocodeLocation(location!) { (placemark, error) -> Void in
            if (error != nil) {
                print(error)
            }
            else{
                self.gpsCityName = (placemark?.first?.locality)!
                self.dataArray[0][0] = self.gpsCityName
                print("省份:\(placemark?.first?.administrativeArea)")
                print("城市:\(placemark?.first?.locality)")
                self.tableView?.reloadData()
                self.locationClosure!(string: self.gpsCityName)
                
                NSUserDefaults.standardUserDefaults().setObject(placemark?.first?.administrativeArea, forKey: "province")
                NSUserDefaults.standardUserDefaults().setObject(placemark?.first?.locality, forKey: "city")
            }
        }
        
        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error)")
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return dataArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell")
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("locationHead")
        headView?.textLabel?.text = alephArray[section]
        headView?.contentView.backgroundColor = UIColor.lightGrayColor()
        return headView!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        locationClosure!(string: (cell?.textLabel?.text)!)
        self.dismissViewControllerAnimated(true, completion: nil)
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
