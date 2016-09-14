//
//  ZIKShaiDanDetailFirstTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZIKShaiDanDetailModel;
@interface ZIKShaiDanDetailFirstTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKShaiDanDetailModel *)model ;
@end
