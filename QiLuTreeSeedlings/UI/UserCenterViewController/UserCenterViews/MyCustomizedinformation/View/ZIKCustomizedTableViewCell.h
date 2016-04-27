//
//  ZIKCustomizedTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKCustomizedModel.h"
@interface ZIKCustomizedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIImageView *changeImageView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKCustomizedModel *)model;

@end
