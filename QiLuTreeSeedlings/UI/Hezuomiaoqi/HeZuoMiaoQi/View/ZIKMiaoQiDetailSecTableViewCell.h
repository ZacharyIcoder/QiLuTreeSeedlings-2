//
//  ZIKMiaoQiDetailSecTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class ZIKMiaoQiDetailModel;
@interface ZIKMiaoQiDetailSecTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKMiaoQiDetailModel *)model ;

@end
