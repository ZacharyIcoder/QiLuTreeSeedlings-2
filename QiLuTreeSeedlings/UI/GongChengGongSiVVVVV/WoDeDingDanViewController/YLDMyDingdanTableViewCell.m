//
//  YLDMyDingdanTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMyDingdanTableViewCell.h"

@implementation YLDMyDingdanTableViewCell
+(YLDMyDingdanTableViewCell *)yldMyDingdanTableViewCell
{
    YLDMyDingdanTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDMyDingdanTableViewCell" owner:self options:nil] lastObject];
    
    return cell;
}
-(void)setModel:(YLDDingDanModel *)model
{
    _model=model;
    self.titleLab.text=model.orderName;
    self.dingdanTypeLab.text=model.orderType;
    self.priceLab.text=model.quotation;
    self.yongmiaodi.text=[NSString stringWithFormat:@"用苗地 %@",model.area];
    self.miaomuPinZhongLab.text =model.miaomu;
    NSArray *fabutimeary=[model.orderDate componentsSeparatedByString:@" "];
    self.fabuRiQiLab.text=[NSString stringWithFormat:@"发布日期:%@",[fabutimeary firstObject]];
    NSArray *endtimeAry=[model.endDate componentsSeparatedByString:@" "];
    self.jiezhiRiqiLab.text=[NSString stringWithFormat:@"截止日期:%@",[endtimeAry firstObject]];
    if ([model.status isEqualToString:@"报价中"]) {
        [self.loggV setImage:[UIImage imageNamed:@""]];
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
