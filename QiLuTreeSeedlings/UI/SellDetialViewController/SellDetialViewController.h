//
//  SellDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@interface SellDetialViewController : UIViewController
@property (nonatomic, assign) NSInteger type;//type == 2,合作苗企
-(id)initWithUid:(HotSellModel *)model;
//- (instancetype)initWithHeZuoMiaoQiUid:(HotSellModel *)model;

@end
