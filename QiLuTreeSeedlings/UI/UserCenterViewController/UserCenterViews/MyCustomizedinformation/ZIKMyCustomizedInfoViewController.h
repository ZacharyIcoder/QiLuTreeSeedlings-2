//
//  ZIKMyCustomizedInfoViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
typedef NS_ENUM(NSInteger, InfoType) {
    InfoTypeMy = 0,        //我的定制信息
    InfoTypeStation = 1    //站长推送定制信息
};
@interface ZIKMyCustomizedInfoViewController : ZIKRightBtnSringViewController
@property (nonatomic, assign) InfoType infoType;
@end
