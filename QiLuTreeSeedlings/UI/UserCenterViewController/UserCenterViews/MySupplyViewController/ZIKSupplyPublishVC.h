//
//  ZIKSupplyPublishVC.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKArrowViewController.h"
#import "SupplyDetialMode.h"

@interface ZIKSupplyPublishVC : ZIKArrowViewController
/**
 *  根据供应详情model初始化ZIKSupplyPublishVC
 *
 *  @param model 供应详情model
 *
 *  @return ZIKSupplyPublishVC
 */
-(id)initWithModel:(SupplyDetialMode*)model;
@end
