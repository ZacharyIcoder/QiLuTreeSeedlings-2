//
//  ZIKWorkstationSelectListViewTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectListViewTableViewCell.h"
@interface ZIKWorkstationSelectListViewTableViewCell ()
@end

@implementation ZIKWorkstationSelectListViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKWorkstationSelectListViewTableViewCellID = @"kZIKWorkstationSelectListViewTableViewCellID";
    ZIKWorkstationSelectListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKWorkstationSelectListViewTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKWorkstationSelectListViewTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}


@end
