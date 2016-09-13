//
//  ZIKStationCenterContentTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterInfoModel,ZIKMiaoQiZhongXinModel;
@interface ZIKStationCenterContentTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(MasterInfoModel *)model;
- (void)configureCellWithMiaoQi:(ZIKMiaoQiZhongXinModel *)model;

@end
