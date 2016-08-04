//
//  YLDGongZuoZhanMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongZuoZhanMessageCell.h"

@implementation YLDGongZuoZhanMessageCell
+(YLDGongZuoZhanMessageCell *)yldGongZuoZhanMessageCell
{
    YLDGongZuoZhanMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGongZuoZhanMessageCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)setModel:(YLDZhanZhangDetialModel *)model
{
    _model=model;
    self.nameLab.text=model.workstationName;
    [self.nameLab sizeToFit];
    self.areaLab.text=model.area;
    if (model.creditMargin.length>0) {
        self.moneyLab.text=[NSString stringWithFormat:@"%@元",model.creditMargin];
    }
    
    self.numLab.text=model.viewNo;
    if ([model.type isEqualToString:@"总站"]) {
        [self.logoV setImage:[UIImage imageNamed:@"yingzhangzongzhan"]];
    }else{
        [self.logoV setImage:[UIImage imageNamed:@"yinzhangfenzhan"]];
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
