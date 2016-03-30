//
//  ZIKMyBalanceFirstTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKMyBalanceFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)data;
@end
