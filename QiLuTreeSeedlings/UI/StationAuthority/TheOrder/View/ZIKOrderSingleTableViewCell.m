//
//  ZIKOrderSingleTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderSingleTableViewCell.h"

@implementation ZIKOrderSingleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKOrderSingleTableViewCellID = @"kZIKOrderSingleTableViewCellID";
    ZIKOrderSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKOrderSingleTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKOrderSingleTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

@end
