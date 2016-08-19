//
//  ZIKIntegraTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKIntegraTableViewCell.h"
#import "UIDefines.h"
#import "ZIKIntegraModel.h"

@implementation ZIKIntegraTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKIntegraTableViewCellID = @"ZIKIntegraTableViewCellID";
    ZIKIntegraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKIntegraTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKIntegraTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKIntegraModel *)model {
    if (model.taskType.integerValue == 1) {//加积分
        self.iconImageView.image = [UIImage imageNamed:@"我的积分-积分增加"];
        self.priceLabel.text = [NSString stringWithFormat:@"+%@",model.score];
        self.priceLabel.textColor = yellowButtonColor;
    }
    else if (model.taskType.integerValue == 2) {//减积分
        self.iconImageView.image = [UIImage imageNamed:@"我的积分-兑换"];
        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.score];
        self.priceLabel.textColor  = NavColor;
    }
    self.timeLable.text = model.createTime;
    self.timeLable.textColor = detialLabColor;
    self.titleLable.text = model.level;
    self.timeLable.textColor = titleLabColor;
}

@end
