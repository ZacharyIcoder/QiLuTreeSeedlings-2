//
//  ZIKSupplyPublishPickImageViewTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/23.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//

#import "ZIKSupplyPublishPickImageViewTableViewCell.h"

@implementation ZIKSupplyPublishPickImageViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKSupplyPublishPickImageViewTableViewCellID = @"ZIKOrderDetailFirstAddressTableViewCellID";
    ZIKSupplyPublishPickImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKSupplyPublishPickImageViewTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKSupplyPublishPickImageViewTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}
@end
