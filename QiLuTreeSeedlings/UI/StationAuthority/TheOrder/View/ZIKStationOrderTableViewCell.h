//
//  ZIKStationOrderTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKStationOrderTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)model;
@end