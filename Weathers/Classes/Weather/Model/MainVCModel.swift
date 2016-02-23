//
//  MainVCModel.swift
//  Weathers
//
//  Created by SR on 16/2/14.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class MainVCModel: NSObject {
    var cellColor = 0
    var temp = ""
    var week = ""
    var logoImageUrl = ""
    
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        print(key)
        return nil
    }
}
