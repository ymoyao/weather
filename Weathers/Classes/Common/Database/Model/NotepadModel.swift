//
//  Notepad_listModel.swift
//  Weathers
//
//  Created by SR on 16/3/16.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class NotepadModel: NSObject {

    //列表页
    var id:Int64 = 0                  //本身ID
    var title = ""              //标题
    var date = ""               //时间
    var style:Int64 = 0               //数据类型
    var star:Bool = false            //是否星标
    
    
    //内容页
    var notepad_list_id:Int64 = 0     //列表的id,用来关联notepad_list表中的数据
    var content = ""            //内容

}
