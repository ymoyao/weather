//
//  Health.swift
//  Weathers
//
//  Created by SR on 16/2/24.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import CoreMotion

open class Health: NSObject {
    
    var instance:Health?
    static let SharedInstance = Health.init()
    private override init(){
        instance? = Health()
        instance?.stepCounter = CMStepCounter.init()
        instance?.operation = OperationQueue.init()
        instance?.todaySteps()
    }
    
    
    var stepCounter:CMStepCounter?
    var operation:OperationQueue?
    open var todayStep = 0
    
    //MARK: - 取到今天凌晨到现在的步数
   fileprivate func todaySteps(){
        
        let date = Date.init()
        let dateFomate = DateFormatter.init()
        dateFomate.dateFormat = "YYYY-MM-dd"
        let dayDateStr = dateFomate.string(from: date)
        let dayDate = dateFomate.date(from: dayDateStr)
        
        stepCounter!.queryStepCountStarting(from: dayDate!, to: Date.init(), to: operation!) { (step, ErrorType) -> Void in
            self.todayStep = step
        }
    }


    /**
     步数求距离
     
     - parameter step: 步数
     
     - returns: 距离（公里）
     */
    open class func getDistance(_ step:Int) -> CGFloat {
    
        return 170.0 * CGFloat(step) / 230000.0
    }
    
    
    open class func getLocalStep() -> Int? {
        if UserDefaults.standard.object(forKey: "localStep") != nil {
          return  UserDefaults.standard.object(forKey: "localStep") as? Int
        }
        else{
            return 0
        }
    }
    
    open class func updateLocalStep(_ step:Int){
        UserDefaults.standard.set(step, forKey: "localStep")
        UserDefaults.standard.synchronize()
    }
    
    open class func getGoalStep() -> Int? {
        if UserDefaults.standard.object(forKey: "goalStep") != nil {
            return  UserDefaults.standard.object(forKey: "goalStep") as? Int
        }
        else{
            return 0
        }
    }
    
    open class func updateGoalStep(_ step:Int){
        UserDefaults.standard.set(step, forKey: "goalStep")
        UserDefaults.standard.synchronize()
    }
    
    
    open class func IsFinishGoal() ->Bool? {
        if UserDefaults.standard.object(forKey: "isFinishGoal") != nil {
            return  UserDefaults.standard.object(forKey: "isFinishGoal") as? Bool
        }
        else{
            return true
        }
    }
    
    open class func finishGoal() {
        UserDefaults.standard.set(true, forKey: "isFinishGoal")
        UserDefaults.standard.synchronize()
    }
    
    open class func beginGoal() {
        UserDefaults.standard.set(false, forKey: "isFinishGoal")
        UserDefaults.standard.synchronize()
    }
    
}
