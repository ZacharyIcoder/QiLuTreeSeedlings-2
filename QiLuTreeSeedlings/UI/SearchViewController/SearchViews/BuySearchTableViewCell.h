//
//  BuySearchTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBuyModel.h"
@interface BuySearchTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)HotBuyModel *hotBuyModel;
@property (nonatomic) BOOL isSelect;
+(NSString *)IDStr;
@end
