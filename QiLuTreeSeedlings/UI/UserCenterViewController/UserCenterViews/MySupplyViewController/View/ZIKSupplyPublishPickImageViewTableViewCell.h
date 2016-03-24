//
//  ZIKSupplyPublishPickImageViewTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/23.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKPickImageView.h"
@interface ZIKSupplyPublishPickImageViewTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet ZIKPickImageView *pickImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)data;

@end
