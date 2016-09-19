//
//  ZIKMiaoQiDetailBriefTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKMiaoQiDetailModel;

@interface ZIKMiaoQiDetailBriefTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKMiaoQiDetailModel *)model ;
@end
