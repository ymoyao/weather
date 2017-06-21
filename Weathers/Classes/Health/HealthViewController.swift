//
//  DetailViewController.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import CoreMotion
import EFCircularSlider
import SnapKit
import SVProgressHUD
import LTMorphingLabel
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class HealthViewController: RootViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    var stepCounter = CMStepCounter.init()
    var todayStep:Int = 0
    var operationQueue = OperationQueue.init()
    
    lazy var photoImageBtn:UIImageView? = {

        let btnTemp = UIImageView.init()
        btnTemp.image = self.getRunImage()
        btnTemp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(HealthViewController.btnClcik))
        btnTemp.addGestureRecognizer(tap)
        btnTemp.backgroundColor = UIColor.lightGray
        btnTemp.clipsToBounds = true
        return btnTemp
    }()
    
    lazy var stepLabel:LTMorphingLabel? = {
        let labelTemp = LTMorphingLabel.init()
        labelTemp.morphingEffect = LTMorphingEffect.burn
        labelTemp.text = "步数: 0步"
        labelTemp.textAlignment = NSTextAlignment.left
        labelTemp.font = UIFont.systemFont(ofSize: 15)
        return labelTemp
    }()
    
    lazy var goalLabel:LTMorphingLabel? = {
        let labelTemp = LTMorphingLabel.init()
        labelTemp.morphingEffect = LTMorphingEffect.sparkle
        labelTemp.text = "目标: 0步"
        labelTemp.textAlignment = NSTextAlignment.center
        labelTemp.font = UIFont.systemFont(ofSize: 15)
        return labelTemp
    }()
    
    lazy var circle:EFCircularSlider? = {
        
        let circleTemp = EFCircularSlider.init()
        circleTemp.minimumValue = 0
        circleTemp.maximumValue = 50000
        circleTemp.lineWidth = 10
        circleTemp.filledColor = UIColor.init(red: 53/255.0, green: 110/255.0, blue: 154/255.0, alpha: 1.0)
        circleTemp.unfilledColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        circleTemp.handleType = .bigCircle
        circleTemp.handleColor = UIColor.white
        return circleTemp
    }()
    
    lazy var circleCurent:EFCircularSlider? = {
        
        let circleTemp = EFCircularSlider.init()
        circleTemp.isUserInteractionEnabled = false
        circleTemp.minimumValue = 0
        circleTemp.maximumValue = 50000
        circleTemp.lineWidth = 10
        circleTemp.filledColor = UIColor.init(red: 53/255.0, green: 110/255.0, blue: 154/255.0, alpha: 1.0)
        circleTemp.unfilledColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        circleTemp.handleType = .semiTransparentWhiteCircle
        circleTemp.handleColor = UIColor.white
        return circleTemp
    }()
    
    lazy var distanceLabel: LTMorphingLabel? = {
        let label = LTMorphingLabel.init()
        label.text = "距离: 0.00公里"
        label.morphingEffect = LTMorphingEffect.anvil
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSHomeDirectory())
        
        //定制导航栏
        loadNavSubView()
        
        //初始化子控件
        loadSubViews()
        
        //初始化步数距离数据
        initHealthStepAndDistance()
        
        //布局
        frameSubViews()
        
        //监控步数
        monitoringStep()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 初始化子控件
    func loadSubViews() {
        
        self.view.addSubview(stepLabel!)
        self.view.addSubview(distanceLabel!)
        self.view.addSubview(circle!)
        self.view.addSubview(circleCurent!)
        self.view.addSubview(photoImageBtn!)
        self.view.addSubview(goalLabel!)
        
    }
    
    func loadNavSubView() {
        self.titleLabel?.text = "健康"
        
        //计算菜单图片的位置
        let width = Utils.calWidthWithLabel(self.titleLabel!)
        let searchImage =  UIImageView.init(image: UIImage.init(named: "nav_search"))
        searchImage.frame = CGRect(x: titleLabel!.frame.size.width / 2 + width / 2, y: 0, width: 20, height: 20)
        titleLabel?.addSubview(searchImage)
        
        self.leftBtn?.isHidden = true
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK: - 选择跑步图片
    func btnClcik() {

        let show = UIActionSheet.init(title: "头像", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册中取")
        show.show(in: self.view)
    }
    
    //MARK: - 初始化步数距离数据
    func initHealthStepAndDistance(){
    
        let date = Date.init()
        let dateFomate = DateFormatter.init()
        dateFomate.dateFormat = "YYYY-MM-dd"
        let dayDateStr = dateFomate.string(from: date)
        let dayDate = dateFomate.date(from: dayDateStr)
        
        stepCounter.queryStepCountStarting(from: dayDate!, to: Date.init(), to: operationQueue) { (step, ErrorType) -> Void in
            DispatchQueue.global(priority: .high).async(execute: { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //实时
                    self.stepLabel?.text = String.init(format: "步数: %ld步", arguments: [step])
                    self.distanceLabel?.text = String.init(format: "距离: %.2f公里", Health.getDistance(step))
                    self.circleCurent?.currentValue = Float(step)
                    self.todayStep = step
                    Health.updateLocalStep(self.todayStep)
                    
                    
                    //目标
                    self.goalLabel?.text = String.init(format: "目标: %ld步", arguments: [Health.getGoalStep()!])
                    self.circle?.currentValue = Float(Health.getGoalStep()!)

                })
            })
        }
    }
    
    //MARK: - 监控步数
    func monitoringStep() {
        
        let ret = CMStepCounter.isStepCountingAvailable()
        if ret {
            stepCounter.startStepCountingUpdates(to: operationQueue, updateOn: 1, withHandler: { (step, date, error) -> Void in
                if step != 0 {
                    //更新本地步数
                    Health.updateLocalStep(step + self.todayStep)
                    
                    //主线程更新UI显示
                    DispatchQueue.global(priority: .high).async(execute: { () -> Void in
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.stepLabel?.text = String.init(format: "步数: %ld步", arguments: [step + self.todayStep])
                            let diatance = Health.getDistance(step + self.todayStep)
                            self.distanceLabel?.text = String.init(format: "距离: %.2f公里", diatance)
                            self.circleCurent?.currentValue = Float(step + self.todayStep)
                        })
                    })

                }
                print("step\(step)")
                
            })
        }
        else{
            SVProgressHUD.showError(withStatus: "您的手机不支持计步")
        }
    }
    
    //MARK: - 保存跑步图片到本地
    func saveToDocumentWithImage(_ image:UIImage) -> Bool{
        var document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        document! += "/Image"
        let fileManager = FileManager.default
        try! fileManager.createDirectory(atPath: document!, withIntermediateDirectories: true, attributes: nil)
        let  imagePath = document! + "/RunImage.png"
        let data = UIImageJPEGRepresentation(image, 1.0)
        let ret = (try? data!.write(to: Foundation.URL(fileURLWithPath: imagePath), options: [.atomic])) != nil
        return ret
    }
    
    //MARK: - 获取到本地跑步图片
    func getRunImage() -> UIImage {
        var imagePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        imagePath! += "/Image/RunImage.png"
        let image = UIImage.init(contentsOfFile: imagePath!)
        if image == nil {
            return UIImage.init()
        }
        return image!
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let ret = saveToDocumentWithImage(image)
        if !ret {
            SVProgressHUD .showError(withStatus: "保存本地失败")
        }
//        photoImageBtn?.setImage(image, forState: UIControlState.Normal)

        photoImageBtn?.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        switch buttonIndex {
        case 1:
            let ret =  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            if ret {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                SVProgressHUD .showError(withStatus: "您手机不支持拍照")
            }

        case 2:
            let ret =  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
            if ret {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        default: break
        }
    }
    
    
    //MARK: - EFCircularSliderDelegate
    func circularSliderContinue(with slider: EFCircularSlider!, andCurrentValue currentValue: Float, andMinimumValue minimumValue: Float, andMaximumValue maximumValue: Float) {
//        stepLabel?.text = String.init(format: "%ld步", Int(currentValue))
//        let diatance = Health.getDistance(Int(currentValue))
//        self.distanceLabel?.text = String.init(format: "%.2f公里", diatance)
        goalLabel?.text = String.init(format: "目标: %ld步", Int(currentValue))

    }
    
    func circularSliderEnd(with slider: EFCircularSlider!, andCurrentValue currentValue: Float, andMinimumValue minimumValue: Float, andMaximumValue maximumValue: Float) {
        
        Health.updateGoalStep(Int(currentValue))
        Health.beginGoal()
        
        Health.SharedInstance.stepCounter?.stopStepCountingUpdates()
        
        Health.SharedInstance.stepCounter?.startStepCountingUpdates(to: Health.SharedInstance.operation!, updateOn: 10, withHandler: { (step, date, error) -> Void in
            print("getLocalStep\(Health.getLocalStep())")
            print("getGoalStep\(Health.getGoalStep())")
            print("step\(step)")
            
            
            if Health.getLocalStep() >= Health.getGoalStep() {
                Health.SharedInstance.stepCounter?.stopStepCountingUpdates()
                Health.finishGoal()
                DispatchQueue.global(priority: .high).async(execute: { () -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        SVProgressHUD.showSuccess(withStatus: "恭喜您完成目标")
                    })
                })
                
            }
        })
    }
    
  
    

    //MARK: - 布局
    func frameSubViews() {
        stepLabel?.snp_makeConstraints({ (make) -> Void in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(64 + 20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        })
        
        distanceLabel?.snp_makeConstraints({ (make) -> Void in
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(64 + 20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        })
        
        circle?.snp_makeConstraints({ (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 200, height: 200))
        })
        
        circleCurent?.snp_makeConstraints({ (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 170, height: 170))
        })
        
        goalLabel?.snp_makeConstraints({ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(circle!.snp_bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(20)
        })
        
        photoImageBtn?.snp_makeConstraints({ (make) -> Void in
            make.center.equalTo(circle!)
            make.size.equalTo(CGSize.init(width: (200-20) / 1.44, height: (200-20) / 1.44))
            photoImageBtn?.layer.cornerRadius = CGFloat((200-20) / 1.44 / 2.0)
        })
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
