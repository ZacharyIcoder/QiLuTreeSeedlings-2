//
//  ZIKHeZuoMiaoQiTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHeZuoMiaoQiTableViewCell.h"
#import "ZIKHeZuoMiaoQiModel.h"

@interface ZIKHeZuoMiaoQiTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@end

@implementation ZIKHeZuoMiaoQiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView  {
    static NSString *kZIKHeZuoMiaoQiTableViewCellID = @"kZIKHeZuoMiaoQiTableViewCellID";
    ZIKHeZuoMiaoQiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKHeZuoMiaoQiTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKHeZuoMiaoQiTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    self.starView.value = (CGFloat)starNum;
}

- (void)configureCell:(ZIKHeZuoMiaoQiModel *)model {
    self.titleLabel.text   = model.companyName;
    self.addressLabel.text = model.companyAddress;
    self.personLabel.text  = model.legalPerson;
}

-(void)setPhoneButtonBlock:(PhoneButtonBlock)phoneButtonBlock {
    _phoneButtonBlock = [phoneButtonBlock copy];
    [self.phoneButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openButtonClick {
    _phoneButtonBlock(self.indexPath);
}

@end
