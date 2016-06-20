//
//  ZIKStationCenterContentTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterContentTableViewCell.h"

@implementation ZIKStationCenterContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationCenterContentTableViewCellID = @"kZIKStationCenterContentTableViewCellID";
    ZIKStationCenterContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationCenterContentTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationCenterContentTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}

@end
