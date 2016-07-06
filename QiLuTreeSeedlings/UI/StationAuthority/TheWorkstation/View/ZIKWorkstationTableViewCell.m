//
//  ZIKWorkstationTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationTableViewCell.h"
#import "ZIKMyTeamModel.h"
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

- (void)configureCell:(ZIKMyTeamModel *)model {
    if ([model.type isEqualToString:@"总站"]) {
        self.logoImageView.image = [UIImage imageNamed:@"yingzhangzongzhan"];
    } else if ([model.type isEqualToString:@"分站"]) {
        self.logoImageView.image = [UIImage imageNamed:@"yinzhangfenzhan"];
    }
    self.addressLabel.text = model.area;
    self.nameLabel.text = [NSString stringWithFormat:@"%@   %@",model.chargelPerson,model.phone];
    self.titleLabel.text = model.workstationName;
    self.numberLabel.text = model.viewNo;

}

- (IBAction)phoneButtonClick:(id)sender {
}

@end
