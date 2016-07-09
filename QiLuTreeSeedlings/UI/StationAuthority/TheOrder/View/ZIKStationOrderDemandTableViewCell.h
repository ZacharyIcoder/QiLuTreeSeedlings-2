//
//  ZIKStationOrderDemandTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZIKStationOrderDemandModel;
@interface ZIKStationOrderDemandTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKStationOrderDemandModel *)model;


@end
