//
//  天气-Bridging-Header.h
//  
//
//  Created by SR on 16/1/27.
//
//

#ifndef ___Bridging_Header_h
#define ___Bridging_Header_h
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import <Foundation/Foundation.h>

//shareSdk API云
#import <mobAPI/MobAPI.h>
#import <MOBFoundation/MOBFJson.h>

#import "PrefixHeader.pch"

//帮助文件
#import "Utils.h"

//图片缓存/下载
#import <SDWebImage/UIImageView+WebCache.h>

//状态框
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVProgressHUD/SVProgressHUD.h>

//画圈
#import <EFCircularSlider/EFCircularSlider.h>

//不带界面的语音识别控件
#import <iflyMSC/IFlyMSC.h>

//弹出载体
#import<KLCPopup/KLCPopup.h>

//#import <sqlite3.h>
//#import "SQLite.h"
//#import "SQLite-Bridging.h"
//#import <SQLite/SQLite.h>
//#import "SQLite-Bridging.h"
//#import "SQLite.h"
//#import "sqlite3.h"


#endif /* ___Bridging_Header_h */
