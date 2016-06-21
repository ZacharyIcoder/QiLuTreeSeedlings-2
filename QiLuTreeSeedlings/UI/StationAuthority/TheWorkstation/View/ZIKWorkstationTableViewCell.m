//
//  ZIKWorkstationTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationTableViewCell.h"

@implementation ZIKWorkstationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKWorkstationTableViewCellID = @"kZIKWorkstationTableViewCellID";
    ZIKWorkstationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKWorkstationTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKWorkstationTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}

@end
