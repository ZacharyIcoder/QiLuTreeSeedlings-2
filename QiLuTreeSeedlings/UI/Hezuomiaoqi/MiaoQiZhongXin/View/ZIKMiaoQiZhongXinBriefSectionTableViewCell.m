//
//  ZIKMiaoQiZhongXinBriefSectionTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinBriefSectionTableViewCell.h"

@implementation ZIKMiaoQiZhongXinBriefSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKMiaoQiZhongXinBriefSectionTableViewCellID = @"kZIKStationCenterContentTableViewCellID";
    ZIKMiaoQiZhongXinBriefSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMiaoQiZhongXinBriefSectionTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMiaoQiZhongXinBriefSectionTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

@end
