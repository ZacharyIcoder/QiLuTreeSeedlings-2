//
//  ZIKStationAgentTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class ZIKStationAgentModel;
typedef void (^PhoneBlock) (NSInteger);
@interface ZIKStationAgentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workstationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargelPersonLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starLevelView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic, copy) PhoneBlock phoneBlock;
@property (nonatomic, assign) NSInteger section;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKStationAgentModel *)model;
@end
