//
//  ZIKIntegraTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKIntegraModel.h"
@interface ZIKIntegraTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKIntegraModel *)data;

@end
