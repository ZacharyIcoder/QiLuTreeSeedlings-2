//
//  ZIKOrderSecondTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

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

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)model;

@end
