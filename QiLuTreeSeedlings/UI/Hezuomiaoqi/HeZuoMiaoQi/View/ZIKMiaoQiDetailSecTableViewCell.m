//
//  ZIKMiaoQiDetailSecTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailSecTableViewCell.h"
#import "ZIKMiaoQiDetailModel.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
@interface ZIKMiaoQiDetailSecTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daibiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 *  星级top
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTopLayoutConxtraint;

@end

@implementation ZIKMiaoQiDetailSecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView.userInteractionEnabled = NO;
    self.moneyLabel.textColor = yellowButtonColor;
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
    CGRect companyNameRect = [ZIKFunction getCGRectWithContent:model.companyName width:self.companyNameLabel.frame.size.width font:15.0f];
    if (companyNameRect.size.height>21) {
        self.starTopLayoutConxtraint.constant = companyNameRect.size.height-21-8;
    }
    self.companyNameLabel.text = model.companyName;
    self.starView.value        = [model.starLevel floatValue];
    self.moneyLabel.text       = [NSString stringWithFormat:@"%@元",model.creditMargin];
    self.daibiaoLabel.text     = model.legalPerson;
    self.phoneLabel.text       = model.phone;
    self.addressLabel.text     = model.address;
}

@end
