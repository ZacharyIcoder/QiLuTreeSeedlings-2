//
//  ZIKStationOrderOfferTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderOfferTableViewCell.h"

@implementation ZIKStationOrderOfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationOrderOfferTableViewCellID = @"kZIKStationOrderOfferTableViewCellID";
    ZIKStationOrderOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationOrderOfferTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationOrderOfferTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}


@end
