//
//  Health.swift
//  Weathers
//
//  Created by SR on 16/2/24.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import CoreMotion

public class Health: NSObject {
    
    var stepCounter:CMStepCounter?
    var operation:NSOperationQueue?
    public var todayStep = 0
    class var SharedInstance : Health {
        struct HealthManager {
            static var onceToken : dispatch_once_t = 0
            static var instance : Health? = nil
        }
        
        dispatch_once(&HealthManager.onceToken) {
            HealthManager.instance = Health()
            HealthManager.instance?.stepCounter = CMStepCounter.init()
            HealthManager.instance?.operation = NSOperationQueue.init()
            HealthManager.instance?.todaySteps()
        }
        return HealthManager.instance!
    }
    
    
    //MARK: - 取到今天凌晨到现在的步数
   private func todaySteps(){
        
        let date = NSDate.init()
        let dateFomate = NSDateFormatter.init()
        dateFomate.dateFormat = "YYYY-MM-dd"
        let dayDateStr = dateFomate.stringFromDate(date)
        let dayDate = dateFomate.dateFromString(dayDateStr)
        
        stepCounter!.queryStepCountStartingFrom(dayDate!, to: NSDate.init(), toQueue: operation!) { (step, ErrorType) -> Void in
            self.todayStep = step
        }
    }


    /**
     步数求距离
     
     - parameter step: 步数
     
     - returns: 距离（公里）
     */
    public class func getDistance(step:Int) -> CGFloat {
    
        return 170.0 * CGFloat(step) / 230000.0
    }
    
    
    public class func getLocalStep() -> Int? {
        if NSUserDefaults.standardUserDefaults().objectForKey("localStep") != nil {
          return  NSUserDefaults.standardUserDefaults().objectForKey("localStep") as? Int
        }
        else{
            return 0
        }
    }
    
    public class func updateLocalStep(step:Int){
        NSUserDefaults.standardUserDefaults().setInteger(step, forKey: "localStep")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public class func getGoalStep() -> Int? {
        if NSUserDefaults.standardUserDefaults().objectForKey("goalStep") != nil {
            return  NSUserDefaults.standardUserDefaults().objectForKey("goalStep") as? Int
        }
        else{
            return 0
        }
    }
    
    public class func updateGoalStep(step:Int){
        NSUserDefaults.standardUserDefaults().setInteger(step, forKey: "goalStep")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    public class func IsFinishGoal() ->Bool? {
        if NSUserDefaults.standardUserDefaults().objectForKey("isFinishGoal") != nil {
            return  NSUserDefaults.standardUserDefaults().objectForKey("isFinishGoal") as? Bool
        }
        else{
            return true
        }
    }
    
    public class func finishGoal() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isFinishGoal")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public class func beginGoal() {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isFinishGoal")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}
