//
//  ZIKShaidanDetailPingZanTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZIKShaiDanDetailModel;
typedef void(^ZanButtonBlock)();

@interface ZIKShaidanDetailPingZanTableViewCell : UITableViewCell
//@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, copy) ZanButtonBlock zanButtonBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
- (void)configureCell:(ZIKShaiDanDetailModel *)model ;

@end
