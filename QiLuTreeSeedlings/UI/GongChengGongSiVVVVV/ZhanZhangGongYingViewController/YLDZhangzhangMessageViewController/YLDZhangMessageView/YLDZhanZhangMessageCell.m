//
//  YLDZhanZhangMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangMessageCell.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDZhanZhangMessageCell
+(YLDZhanZhangMessageCell *)yldZhanZhangMessageCell
{
    YLDZhanZhangMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDZhanZhangMessageCell" owner:self options:nil] lastObject];
    cell.UserImageV.layer.masksToBounds=YES;
    cell.UserImageV.layer.cornerRadius=cell.UserImageV.frame.size.width/2;
    return cell;
}
-(void)setModel:(YLDZhanZhangDetialModel *)model{
    _model=model;
    self.titileLab.text=model.workstationName;
    self.nameLab.text=model.chargelPerson;
    self.unkonwLab.text=model.phone;
    [self.UserImageV setImageWithURL:[NSURL URLWithString:model.workstationPic] placeholderImage:[UIImage imageNamed:@"UserImage.png"]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showShopAction)];
    self.UserImageV.userInteractionEnabled=YES;
    [self.UserImageV addGestureRecognizer:tap];

}
-(void)showShopAction
{
    if ([self.delegate respondsToSelector:@selector(showShopAcionWithUid:)]) {
        [self.delegate showShopAcionWithUid:self.model.memberUid];
    }
}
- (IBAction)BackBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(backBtnAction:)]) {
        [self.delegate backBtnAction:sender];
    }
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
