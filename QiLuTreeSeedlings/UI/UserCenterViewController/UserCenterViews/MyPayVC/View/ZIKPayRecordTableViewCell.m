//
//  ZIKPayRecordTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPayRecordTableViewCell.h"
#import "UIDefines.h"
#import "ZIKConsumeRecordModel.h"

@implementation ZIKPayRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKPayRecordTableViewCellID = @"ZIKPayRecordTableViewCellID";
    ZIKPayRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKPayRecordTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKPayRecordTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKConsumeRecordModel *)model {
    if ([model.type isEqualToString:@"1"]) {//消费
    self.typeImgeView.image   = [UIImage imageNamed:@"消费记录-消费"];
    self.priceLabel.textColor = NavColor;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ : -%@",model.price];
    }
    else if ([model.type isEqualToString:@"0"]) {//充值
    self.typeImgeView.image   = [UIImage imageNamed:@"消费记录-充值"];
    self.priceLabel.textColor = kRGB(241, 157, 65, 1);
    self.priceLabel.text = [NSString stringWithFormat:@"¥ : +%@",model.price];
    }

    self.typeNameLabel.text   = model.reason;
    self.timeLabel.text       = model.time;
}

@end
