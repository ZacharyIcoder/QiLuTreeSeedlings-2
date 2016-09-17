//
//  ZIKShaiDanDetaiPingLunTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKShaiDanDetailPingLunModel;

typedef void(^DeleteButtonBlock)(NSIndexPath *indexPath);

@interface ZIKShaiDanDetaiPingLunTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath  *indexPath;
@property (nonatomic, copy) DeleteButtonBlock deleteButtonBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKShaiDanDetailPingLunModel *)model ;
@end
