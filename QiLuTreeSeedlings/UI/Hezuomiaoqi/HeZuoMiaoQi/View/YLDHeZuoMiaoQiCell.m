//
//  YLDHeZuoMiaoQiCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoMiaoQiCell.h"

@implementation YLDHeZuoMiaoQiCell
+(YLDHeZuoMiaoQiCell *)yldHeZuoMiaoQiCell
{
    YLDHeZuoMiaoQiCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDHeZuoMiaoQiCell" owner:self options:nil] lastObject];
    cell.startView.userInteractionEnabled=NO;
    return cell;
}
-(void)setModel:(ZIKHeZuoMiaoQiModel *)model{
    _model=model;
    self.titleLab.text=model.companyName;
    self.addressLab.text=model.companyAddress;
    self.personLab.text=[NSString stringWithFormat:@"%@ %@",model.legalPerson,model.phone];
    self.startView.value = (CGFloat)model.starLevel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
