//
//  ZIKSupplyPublishSingleTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/23.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//
// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height


#import <UIKit/UIKit.h>

@interface ZIKSupplyPublishSingleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)data;
@end
