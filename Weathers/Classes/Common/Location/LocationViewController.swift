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
import SVProgressHUD

typealias LocationClosure = (string:String) -> Void

class LocationViewController: RootViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    var locationClosure:LocationClosure?
    
    var titleView:UILabel! = UILabel()
    var locationManager:CLLocationManager?
    var tableView:UITableView?
    var searchBar:UISearchBar?
    var dataArray = [Array<String>]()
    var dataSubArray = [String]()
    var searchArray = [String]()
    var isSearchIng:Bool = false
    var gpsCityName:String! = "正在定位..."
    let alephArray = ["GPS定位到的城市","A","B","C","D","E","F","G","H","I","J","k","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"] //i o u v没有
//    let alephArray = ["GPS定位到的城市","A","B","C","D","E","F","G","H","J","k","L","M","N","P","Q","R","S","T","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //监听键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTableHeight:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0)

        self.titleLabel?.text = self.navigationItem.title;
        
        //初始化数据
        initCityData()
        
        //初始化子控件
        initSubViews()
        
        //初始化定位控制器
        initLocationManager()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 初始化子控件
    func initSubViews() {
        

        searchBar = UISearchBar.init(frame: CGRectMake(0, 69, Utils.screenWidth(), 20))
        searchBar?.delegate = self
        self.view.addSubview(searchBar!)
        
        tableView = UITableView.init(frame: CGRectMake(0, 94, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), style: UITableViewStyle.Plain)
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
            if #available(iOS 9.0, *) {
                locationManager!.allowsBackgroundLocationUpdates = true
            } else {
                // Fallback on earlier versions
            }
        }
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func initCityData() {
        print(NSHomeDirectory())

        
        //字段
        let name = Expression<String?>("city")
        let aleph = Expression<String?>("aleph")
        
        let path = NSBundle.mainBundle().pathForResource("citys", ofType: "sqlite3")
        let db = try! Connection(path!, readonly: true)

        let city = Table("city")
        
        var lastCityAleph:String! = ""
        var array = [String]()
        
        //添加首组数据
        self.dataArray.append([self.gpsCityName])
        self.dataSubArray.append(self.gpsCityName)
        self.tableView?.reloadData()
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
           
            //遍历
            for cityRow in try! db.prepare(city.order(aleph)) {
                
                let cityName = cityRow[name]!
                let cityAleph = cityRow[aleph]!
                
                if (lastCityAleph != cityAleph && lastCityAleph != "") || cityName == "昭苏"{
                    if cityName == "昭苏" {
                        array.append(cityName)
                    }
                    self.dataArray.append(array)
                    array.removeAll()
                }
                else{
                    array.append(cityName)
                }
                self.dataSubArray.append(cityName)
                
                lastCityAleph = cityAleph
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
            })
        }

    }
    
    
    //MARK: - 返回上级
    override func leftBtnClick() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //监听键盘改变事件
    func changeTableHeight(not:NSNotification) {
        let valueStr = not.userInfo!["UIKeyboardFrameEndUserInfoKey"]
        let str = String(valueStr)
        let range = Range.init(start: str.startIndex.advancedBy(22), end: str.startIndex.advancedBy(25))
        let valueFloat = Float(str.substringWithRange(range))
        if valueFloat == Float(Utils.screenHeight())  {
            var frame = self.tableView?.frame
            frame?.size.height = Utils.screenHeight() - 84
            self.tableView?.frame = frame!
        }
        else{
            var frame = self.tableView?.frame
            frame?.size.height = CGFloat.init(valueFloat! - 94)
            self.tableView?.frame = frame!
        }
        
    }

    //MARK: - CLLocationManagerDelegate
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
         
                if  self.gpsCityName.componentsSeparatedByString("市").count > 0 {
                    let range =  self.gpsCityName.rangeOfString("市")
                    self.gpsCityName.removeRange(range!)
                }
                
                self.dataArray[0][0] = self.gpsCityName
                print("省份:\(placemark?.first?.administrativeArea)")
                print("城市:\(placemark?.first?.locality)")
                self.tableView?.reloadData()
              
                
                NSUserDefaults.standardUserDefaults().setObject(placemark?.first?.administrativeArea, forKey: "province")
                NSUserDefaults.standardUserDefaults().setObject(self.gpsCityName, forKey: "city")
            }
        }
        
        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error)")
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !isSearchIng {
            return dataArray.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if !isSearchIng {
            return dataArray[section].count
        }
        return searchArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell")
        if !isSearchIng {
            cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        }
        else{
            cell?.textLabel?.text = searchArray[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isSearchIng {
            return 30
        }
        return 0.01
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("locationHead")
        if !isSearchIng {
            headView?.textLabel?.text = alephArray[section]
            headView?.contentView.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0)
        }
        return headView!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        guard cell?.textLabel?.text != "正在定位..." else {
            return
        }
        
        NSUserDefaults.standardUserDefaults().setObject(cell?.textLabel?.text, forKey: "city")
        let path = NSBundle.mainBundle().pathForResource("city", ofType: "sqlite3")
        let db = try! Connection(path!, readonly: true)
        
        let stmt = try! db.prepare("SELECT province FROM city where name = ?")
        try! stmt.run(cell?.textLabel?.text)
        for row in stmt {
            for (index, _) in stmt.columnNames.enumerate() {
                
                let strArr =  String(row[index]).componentsSeparatedByString("\"")
                if strArr.count >= 1 {
                    NSUserDefaults.standardUserDefaults().setObject(strArr[1], forKey: "province")
                }
            }
        }
        locationClosure!(string: (cell?.textLabel?.text)!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        //构建正则(包含)
        let preicate = NSPredicate.init(format: "SELF CONTAINS[c] %@", searchText)
  
        //清除原先搜索数据
        self.searchArray.removeAll()

        
        SVProgressHUD.showWithStatus("查询中...")
        //另外开线程，避免UI因数据量大卡顿
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            //在数据数组中找出符合的的数据放在搜索数据中
            let data = NSMutableArray.init(array: self.dataSubArray)
            self.searchArray = data.filteredArrayUsingPredicate(preicate) as! [String]
            
            //主线程更新UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView?.reloadData()
                SVProgressHUD.dismiss()
            })
            
        }
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("start search")
        isSearchIng = true
        searchBar.showsCancelButton = true
        self.tableView?.reloadData()
        return true
    }
    
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        print("end search")
        isSearchIng = false
        searchBar.showsCancelButton = false
        self.tableView?.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //MARK: - 开始点击
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
