//
//  ZIKWorkstationTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKMyTeamModel;
@interface ZIKWorkstationTableViewCell : UITableViewCell
/**
 *  工作站imageView(总站，分站)
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
/**
 *  工作站名称
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  工作站编号
 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/**
 *  工作站地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 *  工作站联系方式
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)model;

@end
