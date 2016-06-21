//
//  YLDZhanZhangMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangMessageCell.h"

@implementation YLDZhanZhangMessageCell
+(YLDZhanZhangMessageCell *)yldZhanZhangMessageCell
{
    YLDZhanZhangMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDZhanZhangMessageCell" owner:self options:nil] lastObject];
    cell.UserImageV.layer.masksToBounds=YES;
    cell.UserImageV.layer.cornerRadius=cell.UserImageV.frame.size.width/2;
    return cell;
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
