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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //加载数据库数据
        loadDBData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(DiaryViewController.changeSearchTableHeight(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        //定制导航栏和按钮
        loadNavSubViews()
        
        //加载子控件
        loadSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 加载子控件
    func loadSubViews() {
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 64, width: Utils.screenWidth(), height: 40))
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false
        self.view.addSubview(searchBar!)
        
    
        tableView = UITableView.init(frame: CGRect(x: 0, y: 104, width: Utils.screenWidth(), height: Utils.screenHeight() - 104 - 49), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.register(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryCell")
        self.view.addSubview(tableView!)
        
        searchTableView = UITableView.init(frame: CGRect(x: 0, y: 104, width: Utils.screenWidth(), height: Utils.screenHeight() - 104 - 49), style: UITableViewStyle.plain)
        searchTableView?.delegate = self
        searchTableView?.dataSource = self
        searchTableView?.isHidden = true
        searchTableView?.showsVerticalScrollIndicator = false
        searchTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        searchTableView?.register(DiaryTableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.view.addSubview(searchTableView!)
    }
    
    //MARK: - 定制导航栏和按钮
    func loadNavSubViews() {
        
        self.titleLabel?.text = "记事本"
        
        //计算菜单图片的位置
        let width = Utils.calWidthWithLabel(self.titleLabel!)
        let searchImage =  UIImageView.init(image: UIImage.init(named: "nav_search"))
        searchImage.frame = CGRect(x: titleLabel!.frame.size.width / 2 + width / 2, y: 0, width: 20, height: 20)
        titleLabel?.addSubview(searchImage)
        
        
        self.leftBtn?.frame = CGRect(x: 10, y: 32, width: 50, height: 20)
        self.leftBtn?.setTitle("编辑", for: UIControlState())
        self.leftBtn?.setTitle("删除", for: UIControlState.selected)
        self.leftBtn?.setImage(UIImage.init(), for: UIControlState())
        self.rightBtn?.isHidden = false
        self.rightBtnT?.isHidden = false
    }
    
    //监听键盘改变事件
    func changeSearchTableHeight(_ not:Notification) {
        let valueStr = not.userInfo!["UIKeyboardFrameEndUserInfoKey"]
        let str = String(describing: valueStr)
        let range = (str.characters.index(str.startIndex, offsetBy: 22) ..< str.characters.index(str.startIndex, offsetBy: 25))
        let valueFloat = Float(str.substring(with: range))
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
        self.leftBtn!.isSelected = !(self.leftBtn!.isSelected)
        self.tableView!.setEditing(self.leftBtn!.isSelected, animated: true)
    }
    
    override func rightBtnTClick() {
        self.rightBtnT!.isSelected = !self.rightBtnT!.isSelected
        
        
            //另外开线程，避免UI因数据量大卡顿
            DispatchQueue.global(priority: .high).async { () -> Void in
              
                if self.isSearchIng == true {
                    if self.rightBtnT?.isSelected == true {
                        //找出包含的数据
                        self.starSearchArray = self.searchArray.filter( { (user: NotepadModel) -> Bool in
                            return  user.star == true
                        })
                    }
                }
                else{
                    if self.rightBtnT?.isSelected == true {
                        //找出包含的数据
                        self.starDataArray = self.dataArray.filter( { (user: NotepadModel) -> Bool in
                            return  user.star == true
                        })
                    }
                }
                
                //主线程更新UI
                DispatchQueue.main.async(execute: { () -> Void in
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
        
        let contentView = UIView.init(frame: CGRect(x: 20, y: 0, width: Utils.screenWidth() - 40, height: 100))
        contentView.backgroundColor = UIColor.black
        contentView.alpha = 0.5
        contentView.layer.cornerRadius = 9
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 10, width: contentView.frame.size.width, height: 20))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "标题"
        contentView.addSubview(titleLabel)
        
        let textField = UITextField.init(frame: CGRect(x: 20, y: 40, width: contentView.frame.size.width - 20*2, height: 30))
        textField.returnKeyType = UIReturnKeyType.done
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "请输入标题"
        textField.delegate = self
        textField.becomeFirstResponder()
        contentView.addSubview(textField)
        
        popView = KLCPopup.init(contentView: contentView, showType: KLCPopupShowType.bounceIn, dismissType: KLCPopupDismissType.bounceOut, maskType: KLCPopupMaskType.clear, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popView?.show(atCenter: CGPoint(x: Utils.screenWidth() / 2, y: 120), in: self.view)

    }
    
    //MARK: - 加载数据库数据
    func loadDBData() {
        DispatchQueue.global(priority: .high).async { () -> Void in
            self.dataArray = DatabaseManager.SharedInstance.selectTable("notepad_list", goalId: nil)
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView?.reloadData()
            })
        }
       
    }

    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //取消第一响应
        textField.resignFirstResponder()
        //取消弹出框
        popView?.dismiss(false)
        
        //数据库
        let model = NotepadModel()
        model.title = textField.text!
        model.date =  Utils.dateStr(Date.init(), dateFormat: "YYYY-MM-dd")
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
    func diaryCellStarDidSelected(_ cell: DiaryTableViewCell, row: Int, btn: UIButton) {
        let model = dataArray[row]
        DatabaseManager.SharedInstance.upadateTable("notepad_list", goalId: model.id, value: nil, star: model.star)
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    
        //清除原先搜索数据
        self.searchArray.removeAll()
        
        
        //另外开线程，避免UI因数据量大卡顿
        DispatchQueue.global(priority: .high).async { () -> Void in
            
            //找出包含的数据
            self.searchArray = self.dataArray.filter( { (user: NotepadModel) -> Bool in
                if self.rightBtnT?.isSelected == true {
                    return (user.title.contains(searchText) && user.star == true)
                }
                return user.title.contains(searchText)
            })
            
            //主线程更新UI
            DispatchQueue.main.async(execute: { () -> Void in
                self.searchTableView?.reloadData()
            })
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("start search")
        isSearchIng = true
        searchBar.showsCancelButton = true
        self.searchTableView?.isHidden = false
        self.searchTableView?.reloadData()
        return true
    }
    
    //收回键盘（把通知的操作在这边做，会快一点）
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("end search")
        isSearchIng = false
        var frame = self.tableView?.frame
        frame?.size.height = Utils.screenHeight() - 104 - 49
        self.searchTableView?.frame = frame!
        return true
    }
    
    //点击cancal
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchTableView?.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView{
            if self.rightBtnT?.isSelected == true {
                return  starSearchArray.count
            }
            return searchArray.count
        }
        
        if self.rightBtnT?.isSelected == true {
            return  starDataArray.count
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! DiaryTableViewCell
            if self.rightBtnT?.isSelected == true {
                cell.cellModel = starSearchArray[indexPath.row]
            }
            else{
                cell.cellModel = searchArray[indexPath.row]
            }
            
            cell.delegate = self
            cell.row = indexPath.row
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell") as! DiaryTableViewCell
        if self.rightBtnT?.isSelected == true {
            cell.cellModel = starDataArray[indexPath.row]
        }
        else{
            cell.cellModel = dataArray[indexPath.row]
        }
        cell.delegate = self
        cell.row = indexPath.row
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DiaryDetailViewController()
        if tableView == searchTableView{
            if self.rightBtnT?.isSelected == true {
                vc.notepad_list_id = starSearchArray[indexPath.row].id
            }
            else{
                vc.notepad_list_id = searchArray[indexPath.row].id
            }
        }
        else
        {
            if self.rightBtnT?.isSelected == true {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard tableView == self.tableView else{
            return
        }
        if editingStyle == UITableViewCellEditingStyle.delete {
            let model = dataArray[indexPath.row]
            DatabaseManager.SharedInstance.deleteTable("notepad_list", goalId: [model.id])
            DatabaseManager.SharedInstance.deleteTable("notepad_content", goalId: [model.id])
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: UITableViewRowAnimation.top)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
