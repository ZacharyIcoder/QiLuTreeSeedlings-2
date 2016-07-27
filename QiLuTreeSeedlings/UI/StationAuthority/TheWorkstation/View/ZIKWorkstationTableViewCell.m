//
//  ZIKWorkstationTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationTableViewCell.h"
#import "ZIKMyTeamModel.h"
#import "ZIKFunction.h"

@interface ZIKWorkstationTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberWidthLayoutConstraint;
@end

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
        self.logoImageView.image = [UIImage imageNamed:@"ico_工作站-总站text"];
    } else if ([model.type isEqualToString:@"分站"]) {
        self.logoImageView.image = [UIImage imageNamed:@"ico_工作站-分站text"];
    }
    self.addressLabel.text = model.area;
    self.nameLabel.text = [NSString stringWithFormat:@"%@   %@",model.chargelPerson,model.phone];
    self.titleLabel.text = model.workstationName;
    self.numberLabel.text = model.viewNo;
    CGRect numberRect = [ZIKFunction getCGRectWithContent:model.viewNo width:120.0f font:13.0f];
    self.numberWidthLayoutConstraint.constant = numberRect.size.width+15;

}

-(void)setPhoneButtonBlock:(PhoneButtonBlock)phoneBlock {
    _phoneButtonBlock = [phoneBlock copy];
    [self.phoneButton addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)phoneBtnClick {
    _phoneButtonBlock(self.indexPath);
}

@end
