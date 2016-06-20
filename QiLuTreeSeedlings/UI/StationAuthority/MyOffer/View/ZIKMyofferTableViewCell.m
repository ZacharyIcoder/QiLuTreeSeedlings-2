//
//  ZIKMyofferTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyofferTableViewCell.h"

@implementation ZIKMyofferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKMyofferTableViewCellID = @"kZIKMyofferTableViewCellID";
    ZIKMyofferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMyofferTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMyofferTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}

@end
