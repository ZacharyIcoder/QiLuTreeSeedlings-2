//
//  ZIKStationOrderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZIKStationOrderModel;

typedef void(^OpenButtonBlock)(NSIndexPath *indexPath);

@interface ZIKStationOrderTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) OpenButtonBlock openButtonBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKStationOrderModel *)model;
@end
