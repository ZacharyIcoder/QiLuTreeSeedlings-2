//
//  ZIKBottomDeleteTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKSupplyBottomSelectButton.h"
#import "UIDefines.h"

#define BOTTOM_DELETE_CELL_HEIGHT 50
@interface ZIKBottomDeleteTableViewCell : UITableViewCell
/**
 *  选中按钮
 */
@property (weak, nonatomic  ) IBOutlet ZIKSupplyBottomSelectButton *seleteImageButton;
/**
 *  选中数量
 */
@property (weak, nonatomic  ) IBOutlet UILabel                     *countLabel;
/**
 *  删除按钮
 */
@property (weak, nonatomic  ) IBOutlet UIButton                    *deleteButton;
/**
 *  是否选择
 */
@property (nonatomic, assign) BOOL                        isAllSelect;
/**
 *  数量
 */
@property (nonatomic, assign  ) NSInteger                   count;

/**
 *  实例化cell
 *
 *  @param tableView tableView description
 *
 *  @return return value description
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
