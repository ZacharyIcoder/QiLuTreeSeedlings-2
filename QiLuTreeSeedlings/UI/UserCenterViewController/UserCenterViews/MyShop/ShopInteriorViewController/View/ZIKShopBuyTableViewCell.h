//
//  ZIKShopBuyTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKShopBuyModel;
@interface ZIKShopBuyTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKShopBuyModel *)model;

@end
