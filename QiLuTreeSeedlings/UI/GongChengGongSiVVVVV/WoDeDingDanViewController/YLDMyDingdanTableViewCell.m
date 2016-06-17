//
//  YLDMyDingdanTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMyDingdanTableViewCell.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@implementation YLDMyDingdanTableViewCell
+(YLDMyDingdanTableViewCell *)yldMyDingdanTableViewCell
{
    YLDMyDingdanTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDMyDingdanTableViewCell" owner:self options:nil] lastObject];
        [cell.showBtn setImage:[UIImage imageNamed:@"ico_橙色收起"] forState:UIControlStateNormal];
    [cell.showBtn setImage:[UIImage imageNamed:@"chengsezhankai"] forState:UIControlStateSelected];
    [cell.showBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
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
    //NSLog(@"%f",.frame.size.height);
    if (model.showHeight<=250) {
        self.showBtn.hidden=YES;
    }else
    {
        self.showBtn.hidden=NO;
    }
    if (model.isShow) {
        CGRect frame=self.frame;
        frame.size.height=model.showHeight;
        self.frame=frame;
        self.miaomuPinZhongLab.numberOfLines=0;
    }else{
        CGRect frame=self.frame;
        frame.size.height=250;
        self.frame=frame;
        self.miaomuPinZhongLab.numberOfLines=1;
    }
    self.showBtn.selected=model.isShow;
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
