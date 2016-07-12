//
//  ZIKWorkstationSelectListViewTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKWorkstationSelectListViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic, copy) NSString *code;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
