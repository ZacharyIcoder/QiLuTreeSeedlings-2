//
//  ZIKStationOrderDemandTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZIKStationOrderDemandModel;
@protocol ZIKStationOrderDemandTableViewCellDelegate <NSObject>

@required
-(void)sendPhoneInfo:(NSString *)phoneString;

@end

@interface ZIKStationOrderDemandTableViewCell : UITableViewCell
@property (nonatomic,assign) id <ZIKStationOrderDemandTableViewCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKStationOrderDemandModel *)model;


@end
