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
@interface ZIKStationCenterContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation ZIKStationCenterContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor    = DarkTitleColor;
    self.numberLabel.textColor  = DarkTitleColor;
    self.addressLabel.textColor = DarkTitleColor;
    self.priceLabel.textColor   = DarkTitleColor;

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
    self.nameLabel.text    = model.workstationName;
    self.numberLabel.text  = model.workstationNo;
    self.addressLabel.text = model.area;
    self.priceLabel.text   = model.creditMargin;
}

@end
