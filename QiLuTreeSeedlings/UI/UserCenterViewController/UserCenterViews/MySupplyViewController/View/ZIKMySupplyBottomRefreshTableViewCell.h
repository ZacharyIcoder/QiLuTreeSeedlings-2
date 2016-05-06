//
//  ZIKMySupplyBottomRefreshTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKMySupplyBottomRefreshTableViewCell : UITableViewCell
/**
 *  合计label
 */
@property (weak, nonatomic    ) IBOutlet UILabel      *countLable;
/**
 *  刷新按钮
 */
@property (weak, nonatomic    ) IBOutlet UIButton     *refreshButton;
/**
 *  数量
 */
@property (nonatomic, assign  ) NSInteger    count;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
