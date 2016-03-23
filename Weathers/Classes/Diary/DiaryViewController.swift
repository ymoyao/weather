//
//  DiaryViewController.swift
//  Weathers
//
//  Created by SR on 16/3/9.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import KLCPopup


class DiaryViewController: RootViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DiaryTableViewCellDelegate,UISearchBarDelegate {

    var tableView:UITableView?
    var searchTableView:UITableView?
    var dataArray = [NotepadModel]()            //总数据
    var searchArray = [NotepadModel]()          //收索数据
    var starDataArray = [NotepadModel]()        //仅标星收索数据（未搜索状态下）
    var starSearchArray = [NotepadModel]()      //仅标星收索数据(搜索状态下)
    var isSearchIng:Bool = false
    var popView:KLCPopup?
    var searchBar:UISearchBar?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载数据库数据
        loadDBData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //监听键盘弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeSearchTableHeight:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        //定制导航栏和按钮
        loadNavSubViews()
        
        //加载子控件
        loadSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 加载子控件
    func loadSubViews() {
        searchBar = UISearchBar.init(frame: CGRectMake(0, 64, Utils.screenWidth(), 40))
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false
        self.view.addSubview(searchBar!)
        
    
        tableView = UITableView.init(frame: CGRectMake(0, 104, Utils.screenWidth(), Utils.screenHeight() - 104 - 49), style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView?.registerClass(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryCell")
        self.view.addSubview(tableView!)
        
        searchTableView = UITableView.init(frame: CGRectMake(0, 104, Utils.screenWidth(), Utils.screenHeight() - 104 - 49), style: UITableViewStyle.Plain)
        searchTableView?.delegate = self
        searchTableView?.dataSource = self
        searchTableView?.hidden = true
        searchTableView?.showsVerticalScrollIndicator = false
        searchTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        searchTableView?.registerClass(DiaryTableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.view.addSubview(searchTableView!)
    }
    
    //MARK: - 定制导航栏和按钮
    func loadNavSubViews() {
        
        self.titleLabel?.text = "记事本"
        
        //计算菜单图片的位置
        let width = Utils.calWidthWithLabel(self.titleLabel!)
        let searchImage =  UIImageView.init(image: UIImage.init(named: "nav_search"))
        searchImage.frame = CGRectMake(titleLabel!.frame.size.width / 2 + width / 2, 0, 20, 20)
        titleLabel?.addSubview(searchImage)
        
        
        self.leftBtn?.frame = CGRectMake(10, 32, 50, 20)
        self.leftBtn?.setTitle("编辑", forState: UIControlState.Normal)
        self.leftBtn?.setTitle("删除", forState: UIControlState.Selected)
        self.leftBtn?.setImage(UIImage.init(), forState: UIControlState.Normal)
        self.rightBtn?.hidden = false
        self.rightBtnT?.hidden = false
    }
    
    //监听键盘改变事件
    func changeSearchTableHeight(not:NSNotification) {
        let valueStr = not.userInfo!["UIKeyboardFrameEndUserInfoKey"]
        let str = String(valueStr)
        let range = Range.init(start: str.startIndex.advancedBy(22), end: str.startIndex.advancedBy(25))
        let valueFloat = Float(str.substringWithRange(range))
        if valueFloat == Float(Utils.screenHeight())  {
//            var frame = self.tableView?.frame
//            frame?.size.height = Utils.screenHeight() - 94 - 49
//            self.searchTableView?.frame = frame!
//            （把通知的操作在收索代理那边做，会快一点）
        }
        else{
            var frame = self.tableView?.frame
            frame?.size.height = CGFloat.init(valueFloat! - 104)
            self.searchTableView?.frame = frame!
        }
        
    }

    
    //MARK: - 编辑
    override func leftBtnClick() {
        self.leftBtn!.selected = !(self.leftBtn!.selected)
        self.tableView!.setEditing(self.leftBtn!.selected, animated: true)
    }
    
    override func rightBtnTClick() {
        self.rightBtnT!.selected = !self.rightBtnT!.selected
        
        
            //另外开线程，避免UI因数据量大卡顿
            dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
              
                if self.isSearchIng == true {
                    if self.rightBtnT?.selected == true {
                        //找出包含的数据
                        self.starSearchArray = self.searchArray.filter( { (user: NotepadModel) -> Bool in
                            return  user.star == true
                        })
                    }
                }
                else{
                    if self.rightBtnT?.selected == true {
                        //找出包含的数据
                        self.starDataArray = self.dataArray.filter( { (user: NotepadModel) -> Bool in
                            return  user.star == true
                        })
                    }
                }
                
                //主线程更新UI
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.isSearchIng == true {
                        self.searchTableView?.reloadData()
                    }
                    else{
                        self.tableView?.reloadData()
                    }
                })
            }
       
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
    
    //MARK: - 加载数据库数据
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
    
    //MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    
        //清除原先搜索数据
        self.searchArray.removeAll()
        
        
        //另外开线程，避免UI因数据量大卡顿
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            
            //找出包含的数据
            self.searchArray = self.dataArray.filter( { (user: NotepadModel) -> Bool in
                if self.rightBtnT?.selected == true {
                    return (user.title.containsString(searchText) && user.star == true)
                }
                return user.title.containsString(searchText)
            })
            
            //主线程更新UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchTableView?.reloadData()
            })
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("start search")
        isSearchIng = true
        searchBar.showsCancelButton = true
        self.searchTableView?.hidden = false
        self.searchTableView?.reloadData()
        return true
    }
    
    //收回键盘（把通知的操作在这边做，会快一点）
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        print("end search")
        isSearchIng = false
        var frame = self.tableView?.frame
        frame?.size.height = Utils.screenHeight() - 104 - 49
        self.searchTableView?.frame = frame!
        return true
    }
    
    //点击cancal
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchTableView?.hidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView{
            if self.rightBtnT?.selected == true {
                return  starSearchArray.count
            }
            return searchArray.count
        }
        
        if self.rightBtnT?.selected == true {
            return  starDataArray.count
        }
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == searchTableView{
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as! DiaryTableViewCell
            if self.rightBtnT?.selected == true {
                cell.cellModel = starSearchArray[indexPath.row]
            }
            else{
                cell.cellModel = searchArray[indexPath.row]
            }
            
            cell.delegate = self
            cell.row = indexPath.row
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as! DiaryTableViewCell
        if self.rightBtnT?.selected == true {
            cell.cellModel = starDataArray[indexPath.row]
        }
        else{
            cell.cellModel = dataArray[indexPath.row]
        }
        cell.delegate = self
        cell.row = indexPath.row
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DiaryDetailViewController()
        if tableView == searchTableView{
            if self.rightBtnT?.selected == true {
                vc.notepad_list_id = starSearchArray[indexPath.row].id
            }
            else{
                vc.notepad_list_id = searchArray[indexPath.row].id
            }
        }
        else
        {
            if self.rightBtnT?.selected == true {
                vc.notepad_list_id = starDataArray[indexPath.row].id
            }
            else{
                vc.notepad_list_id = dataArray[indexPath.row].id
            }
        }
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = "新建"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard tableView == self.tableView else{
            return
        }
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
