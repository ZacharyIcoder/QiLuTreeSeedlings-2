//
//  MySupplyOtherInfoTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyDetialMode.h"
@interface MySupplyOtherInfoTableViewCell : UITableViewCell
@property (nonatomic,strong)SupplyDetialMode *model;
@property (nonatomic,weak)NSArray *nuseryAry;
+(NSString *)IDStr;
@end
