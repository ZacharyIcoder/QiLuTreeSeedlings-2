//
//  YLDGongChengZhongXinBigCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongChengZhongXinBigCell.h"

@implementation YLDGongChengZhongXinBigCell
+(YLDGongChengZhongXinBigCell *)yldGongChengZhongXinBigCell
{
    YLDGongChengZhongXinBigCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGongChengZhongXinBigCell" owner:self options:nil] lastObject];
    cell.userImagV.layer.masksToBounds=YES;
    cell.userImagV.layer.cornerRadius=cell.userImagV.frame.size.height/2;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(YLDGCGSModel *)model
{
    _model=model;
    self.companyName.text=model.companyName;
    self.personName.text=model.legalPerson;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)BackBtnAction:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"YLDBackMiaoXinTong" object:nil];
}
- (IBAction)shareBtnAction:(UIButton *)sender {
}
@end
