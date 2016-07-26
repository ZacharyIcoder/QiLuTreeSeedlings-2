//
//  YLDShopYuanCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDShopYuanCellsDelegate <NSObject>

- (void)YLDShopYuanCellPush:(NSInteger)index;

@end
@interface YLDShopYuanCell : UITableViewCell
@property (nonatomic,weak) id<YLDShopYuanCellsDelegate> delegate;
@end
