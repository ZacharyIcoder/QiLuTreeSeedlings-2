//
//  ZIKMiaoQiZhongXinBriefSectionTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKMiaoQiZhongXinModel;

typedef void(^OpenButtonBlock)(NSIndexPath *indexPath);

@interface ZIKMiaoQiZhongXinBriefSectionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) OpenButtonBlock openButtonBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKMiaoQiZhongXinModel *)model;
@end
