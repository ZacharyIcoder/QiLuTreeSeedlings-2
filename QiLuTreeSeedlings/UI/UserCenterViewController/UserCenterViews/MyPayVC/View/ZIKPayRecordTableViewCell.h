//
//  ZIKPayRecordTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKConsumeRecordModel.h"
@interface ZIKPayRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImgeView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)data;

@end
