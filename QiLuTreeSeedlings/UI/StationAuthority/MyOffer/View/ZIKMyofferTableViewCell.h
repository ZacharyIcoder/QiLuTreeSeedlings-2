//
//  ZIKMyofferTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKMyofferTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)model;
@end
