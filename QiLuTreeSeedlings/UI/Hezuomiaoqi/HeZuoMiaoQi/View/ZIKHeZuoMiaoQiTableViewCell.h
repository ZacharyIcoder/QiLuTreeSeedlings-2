//
//  ZIKHeZuoMiaoQiTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class ZIKHeZuoMiaoQiModel;
@interface ZIKHeZuoMiaoQiTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger starNum;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKHeZuoMiaoQiModel *)model;
@end
