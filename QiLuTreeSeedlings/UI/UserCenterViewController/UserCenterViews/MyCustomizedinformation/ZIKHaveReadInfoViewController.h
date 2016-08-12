//
//  ZIKHaveReadInfoViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKArrowViewController.h"
//@class ZIKMyCustomizedInfoViewController;
#import "ZIKMyCustomizedInfoViewController.h"
@interface ZIKHaveReadInfoViewController : ZIKArrowViewController

/**
 *  产品uid
 */
@property (nonatomic, copy) NSString *uidStr;
/**
 *  定制名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  定制分类（我的定制，站长定制）
 */
@property (nonatomic, assign) InfoType infoType;
@end
