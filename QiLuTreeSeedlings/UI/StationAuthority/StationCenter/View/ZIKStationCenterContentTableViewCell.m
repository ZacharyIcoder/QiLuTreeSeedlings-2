//
//  ZIKStationCenterContentTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterContentTableViewCell.h"
#import "MasterInfoModel.h"
#import "UIDefines.h"
#import "ZIKMiaoQiZhongXinModel.h"
@interface ZIKStationCenterContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *headThirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *headFourLabel;

@end
@implementation ZIKStationCenterContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor    = DarkTitleColor;
    self.numberLabel.textColor  = DarkTitleColor;
    self.addressLabel.textColor = DarkTitleColor;
    self.priceLabel.textColor   = yellowButtonColor;

  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationCenterContentTableViewCellID = @"kZIKStationCenterContentTableViewCellID";
    ZIKStationCenterContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationCenterContentTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationCenterContentTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(MasterInfoModel *)model {
    self.headNameLabel.text   = @"工作站名称";
    self.headSecondLabel.text = @"工作站编号";
    self.headThirdLabel.text  = @"工作站地址";
    self.headFourLabel.text   = @"诚信保证金";

    self.nameLabel.text    = model.workstationName;
    self.numberLabel.text  = model.viewNo;
    self.addressLabel.text = model.area;
    self.priceLabel.text   = [NSString stringWithFormat:@"%@元",model.creditMargin];
    if ([model.type isEqualToString:@"总站"]) {
        self.typeImageView.image = [UIImage imageNamed:@"yingzhangzongzhan"];
    } else if ([model.type isEqualToString:@"分站"]) {
        self.typeImageView.image = [UIImage imageNamed:@"yinzhangfenzhan"];
    }
}

- (void)configureCellWithMiaoQi:(ZIKMiaoQiZhongXinModel *)model {
    self.headNameLabel.text   = @"公司名称";
    self.headSecondLabel.text = @"联系人";
    self.headThirdLabel.text  = @"公司地址";
    self.headFourLabel.text   = @"诚信保证金";

    self.nameLabel.text    = model.companyName;
    self.numberLabel.text  = model.name;
    self.addressLabel.text = model.area;
    self.priceLabel.text   = [NSString stringWithFormat:@"%@元",model.creditMargin];

    self.typeImageView.image = [UIImage imageNamed:@"印章-分站"];
}


@end
