//
//  SellBanderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyDetialMode.h"
#import "HotSellModel.h"
@interface SellBanderTableViewCell : UITableViewCell

-(id)initWithFrame:(CGRect)frame andModel:(SupplyDetialMode*)model andHotSellModel:(HotSellModel *)hotModel;
@end
