//
//  ZIKSupplyPUblishNextFirstTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPUblishNextFirstTableViewCell.h"

@implementation ZIKSupplyPUblishNextFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKSupplyPUblishNextFirstTableViewCellID = @"ZIKSupplyPUblishNextFirstTableViewCellID";
    ZIKSupplyPUblishNextFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKSupplyPUblishNextFirstTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKSupplyPUblishNextFirstTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)configureCell:(id)data {

}

@end
