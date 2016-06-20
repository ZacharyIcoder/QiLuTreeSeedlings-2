//
//  ZIKOrderSecondTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZIKOrderSecondTableViewCellDelegate <NSObject>

@required
-(void)sendTimeSortInfo:(NSDictionary *)timeSortDic;

@end

@interface ZIKOrderSecondTableViewCell : UITableViewCell
/**
 *  发布时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
/**
 *  截止时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
/**
 *  筛选按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *screeningButton;
/**
 *  选择发布截止时间的delegate
 */
@property (nonatomic, assign) id<ZIKOrderSecondTableViewCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(id)model;

@end
