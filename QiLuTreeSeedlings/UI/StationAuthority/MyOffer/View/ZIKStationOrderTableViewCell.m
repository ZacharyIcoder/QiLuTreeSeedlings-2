//
//  ZIKStationOrderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderTableViewCell.h"

@implementation ZIKStationOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationOrderTableViewCellID = @"kZIKStationOrderTableViewCellID";
    ZIKStationOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationOrderTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationOrderTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}


@end
