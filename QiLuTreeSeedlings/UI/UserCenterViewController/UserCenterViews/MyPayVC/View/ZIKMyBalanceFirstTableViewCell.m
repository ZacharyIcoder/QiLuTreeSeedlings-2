//
//  ZIKMyBalanceFirstTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyBalanceFirstTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKMyBalanceFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLabel.textColor = yellowButtonColor;
    //NSLog(@"%@",APPDELEGATE.userModel.balance);
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",APPDELEGATE.userModel.balance.floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKMyBalanceFirstTableViewCellID = @"ZIKMyBalanceFirstTableViewCellID";
    ZIKMyBalanceFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKMyBalanceFirstTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMyBalanceFirstTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(NSString *)priceString {
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",priceString.floatValue];
}

@end
