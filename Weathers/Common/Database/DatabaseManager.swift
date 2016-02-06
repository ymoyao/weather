//
//  DatabaseManager.swift
//  Weather
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation


class DatabaseManager: NSObject {

    var databaseFilePath:String?
//    var database:sqlite3?
    
    class var SharedInstance : DatabaseManager {
        struct Database {
            static var onceToken : dispatch_once_t = 0
            static var instance : DatabaseManager? = nil
        }
        
        dispatch_once(&Database.onceToken) {
            Database.instance = DatabaseManager()
        }
        return Database.instance!
    }
    
    
//    func createAndOpenSQL(sqlpath:String , type:String) {
//        
//        self.databaseFilePath = NSBundle.mainBundle().pathForResource(sqlpath, ofType: type)
//        if(sqlite3_open(self.databaseFilePath?.utf8,&datab))
//        
//        
//        
//        if (sqlite3_open([self.databaseFilePath UTF8String], &database) == SQLITE_OK) {
//            NSLog(@"打开数据库ok！");
//        }else{
//            sqlite3_close(database);
//            NSLog(@"打开数据库失败！");
//        }
//    }

    
}
