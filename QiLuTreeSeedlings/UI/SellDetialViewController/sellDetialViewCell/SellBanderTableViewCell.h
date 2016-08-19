//
//  SellBanderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupplyDetialMode;
@class HotSellModel;
@protocol SellBanderDelegate <NSObject>

- (void)showBigImageWtihIndex:(NSInteger )index;

@end
@interface SellBanderTableViewCell : UITableViewCell
@property (nonatomic,weak) id<SellBanderDelegate>delegate;
-(id)initWithFrame:(CGRect)frame andModel:(SupplyDetialMode*)model andHotSellModel:(HotSellModel *)hotModel;
@end
