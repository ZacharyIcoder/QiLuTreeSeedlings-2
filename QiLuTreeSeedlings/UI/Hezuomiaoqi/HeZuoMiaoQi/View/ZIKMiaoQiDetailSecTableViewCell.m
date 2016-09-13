//
//  ZIKMiaoQiDetailSecTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailSecTableViewCell.h"
#import "ZIKMiaoQiDetailModel.h"
@interface ZIKMiaoQiDetailSecTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daibiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation ZIKMiaoQiDetailSecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKMiaoQiDetailSecTableViewCellID = @"kZIKMiaoQiDetailSecTableViewCellID";
    ZIKMiaoQiDetailSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMiaoQiDetailSecTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMiaoQiDetailSecTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKMiaoQiDetailModel *)model {
    self.companyNameLabel.text = model.companyName;
    self.starView.value        = [model.starLevel floatValue];
    self.moneyLabel.text       = model.creditMargin;
    self.daibiaoLabel.text     = model.name;
    self.phoneLabel.text       = model.phone;
    self.addressLabel.text     = model.address;
}

@end
