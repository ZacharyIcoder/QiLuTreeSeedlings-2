//
//  SellSearchTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@interface SellSearchTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)HotSellModel *hotSellModel;
+(NSString *)IDStr;
@end
