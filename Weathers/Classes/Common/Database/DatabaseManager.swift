//
//  DatabaseManager.swift
//  Weather
//
//  Created by SR on 16/2/4.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit
import Foundation
import SQLite


class DatabaseManager: NSObject {
    var instance : DatabaseManager?
    static let SharedInstance = DatabaseManager.init()
    private override init(){
        instance = DatabaseManager()
        instance?.openDB()
    }

    var databaseFilePath:String?
    var db:Connection?
    
    //创建创建数据库文件夹和数据库并打开数据库
    func openDB() {
        
        //创建数据库文件夹
        let dbPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let dbPathTemp = dbPath! + "/DB"
        let fileManager =  FileManager.init()
        if  !fileManager.fileExists(atPath: dbPathTemp) {
            try! fileManager.createDirectory(atPath: dbPathTemp, withIntermediateDirectories: true, attributes: nil)
        }
        
        //创建和打开数据库
        let dbFilePathTemp = dbPathTemp + "/db.sqlite3"
        db = try! Connection.init(dbFilePathTemp)
        //创建表(列表页)
        createTableNotepad_list()
        
        //创建表(内容页)
        createTableNotepad_content()
    }
    
    //MARK: - 创建表notepad_list(列表页)
    func createTableNotepad_list() {
        let table = Table("notepad_list")
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")                 //标题
        let date = Expression<String>("date")                   //日期
        let style = Expression<Int64>("style")                  //类型
        let star = Expression<Bool>("star")                     //是否星标
        
        try! db!.run(table.create(ifNotExists:true) { t in     // CREATE TABLE "tabel" IF NOT EXISTS (
            t.column(id, primaryKey: true)                     //     "id" INTEGER PRIMARY KEY NOT NULL,
            t.column(title)                                    //     "title" TEXT ,
            t.column(date)
            t.column(style)
            t.column(star)
            })

    }
    
    //MARK: - 创建表notepad_content(内容页)
    func createTableNotepad_content() {
        let table = Table("notepad_content")
        let id = Expression<Int64>("id")
        let content = Expression<String>("content")                                 //内容
        let notepad_list_id = Expression<Int64>("notepad_list_id")                    //notepad_list的id
        
        try! db!.run(table.create(ifNotExists:true) { t in
            t.column(id, primaryKey: true)
            t.column(notepad_list_id)
            t.column(content)

            })
    }
    
    
    //MARK: - 插入数据
    func insertTable(_ name:String, data:[NotepadModel]) ->Bool {
        var sqlStr = ""
        var style = 0
        if name == "notepad_list" {
            style = 1
            sqlStr = "(title,date,style,star) VALUES (?,?,?,?)"
        }
        else if name == "notepad_content" {
            style = 2
            sqlStr = "(content,notepad_list_id) VALUES (?,?)"
        }
        
        guard sqlStr != "" else{
            return false
        }
        
        sqlStr  = "INSERT INTO " + name + sqlStr
        let stmt = try! db!.prepare(sqlStr)
        for model in data {
            switch style {
            case 1:
                try! stmt.run(model.title,model.date,model.style,model.star)
            case 2:
                try! stmt.run(model.content,model.notepad_list_id)
            default:break
            }
        }
        return true
    }
    
    
    //MARK: - 查找数据
    func selectTable(_ name:String, goalId:Int64?) ->[NotepadModel] {
    
        var array:[NotepadModel] = []
        let table = Table(name)
        
        if name == "notepad_list" {
            let id = Expression<Int64>("id")
            let title = Expression<String>("title")                 //标题
            let date = Expression<String>("date")                   //日期
            let style = Expression<Int64>("style")                  //类型
            let star = Expression<Bool>("star")                     //是否星标
            for value in try! db!.prepare(table) {
                let model = NotepadModel()
                model.id = value[id]
                model.title = value[title]
                model.date = value[date]
                model.style = value[style]
                model.star = value[star]
                array.append(model)
            }
        }
        else if name == "notepad_content" {
            let id = Expression<Int64>("id")
            let content = Expression<String>("content")                                     //内容
            let notepad_list_id = Expression<Int64>("notepad_list_id")                    //notepad_list的id
            for value in try! db!.prepare(table) {
                if goalId == value[notepad_list_id] {
                    let model = NotepadModel()
                    model.id = value[id]
                    model.content = value[content]
                    model.notepad_list_id = value[notepad_list_id]
                    array.append(model)
                }
              
            }

        }

        return array
    }
    
    
    //MARK: - 删除数据
    func deleteTable(_ name:String, goalId:[Int64]?) -> Bool {

        if  name == "notepad_list" {
            for value in goalId! {
                var sqlStr = " WHERE id = " + String.init(format: "%ld", value)
                sqlStr  = "DELETE FROM " + name + sqlStr
                let stmt = try! db!.prepare(sqlStr)
                try! stmt.run()
            }
        }
        else if name == "notepad_content" {
            for value in goalId! {
                var sqlStr = " WHERE notepad_list_id = " + String.init(format: "%ld", value)
                sqlStr  = "DELETE FROM " + name + sqlStr
                let stmt = try! db!.prepare(sqlStr)
                try! stmt.run()
            }
        }
        
        
        return true
    }
    
    //MARK: - 更新数据
    func upadateTable(_ name:String, goalId:Int64?, value:String? ,star:Bool?) -> Bool {
        
        if name == "notepad_content" {
            //1.字符串要加 ''  数字不用加 ;2.  注意空格
            //UPDATE table_name
            //SET column1 = value1, column2 = value2...., columnN = valueN
            //WHERE [condition];
            var sqlStr = " SET content = '" + value! +  "' WHERE notepad_list_id = " + String.init(format: "%ld", goalId!)
            sqlStr  = "UPDATE " + name + sqlStr
            let stmt = try! db!.prepare(sqlStr)
            try! stmt.run()
            return true
        }
        else if name == "notepad_list" {
            var sqlStr = " SET star = " + String.init(format: "%i", Bool(star!) as CVarArg) + " WHERE id = " + String.init(format: "%ld", goalId!)
            sqlStr  = "UPDATE " + name + sqlStr
            let stmt = try! db!.prepare(sqlStr)
            try! stmt.run()
            return true
        }
        return false
        
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
