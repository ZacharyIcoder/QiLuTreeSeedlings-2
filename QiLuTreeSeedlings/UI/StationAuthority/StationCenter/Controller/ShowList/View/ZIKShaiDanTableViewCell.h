//
//  ZIKShaiDanTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZIKShaiDanModel;
@interface ZIKShaiDanTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKShaiDanModel *)model ;
@end
