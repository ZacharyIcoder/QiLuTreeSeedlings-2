//
//  ZIKCustomizedInfoListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKCustomizedInfoListModel;
@interface ZIKCustomizedInfoListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)configureCell:(ZIKCustomizedInfoListModel *)model;
@end
