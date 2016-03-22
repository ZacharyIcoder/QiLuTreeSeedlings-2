//
//  UIDefines.h
//  baba88
//
//  Created by JCAI on 15/7/16.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#ifndef UIDefines_h
#define UIDefines_h

#import "AppDelegate.h"
#import "ToastView.h"
#import "UserInfoModel.h"
#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define ShowTopToast(text) {\
[ToastView showToast:text\
withOriginY:66.0f\
withSuperView:APPDELEGATE.window];\
}

#define ShowToast(text) {\
[ToastView showToast:text\
withOriginY:[[UIScreen mainScreen] bounds].size.height-100\
withSuperView:APPDELEGATE.window];\
}
#define SCALING         (APPDELEGATE.scaling)

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kRGB(R,G,B,P) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:P]


#pragma mark - 颜色设置
#define NavColor        [UIColor colorWithRed:107/255.0f green:188/255.0f blue:85/255.0f alpha:1.0f]
#define BGColor         [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f] 
//#define BGColor         [UIColor whiteColor]
#define kLineColor       [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]

#pragma mark- 对屏幕尺寸进行判断
#define iPhone35Inch            (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define iPhone47InchLater       (([[UIScreen mainScreen] bounds].size.height >= 667) ? YES : NO)

#define ksearchHistoryAry @"searchHistoryAry"

#define kACCESS_ID @"access_id"
#define kACCESS_TOKEN @"access_token"
#define kdeviceToken @"deviceToken"
#endif
