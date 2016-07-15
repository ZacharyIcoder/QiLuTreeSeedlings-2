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
    [cell.hezuoBtn setEnlargeEdgeWithTop:5 right:10 bottom:10 left:10];
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
    if (model.showHeight<=190) {
        self.showBtn.hidden=YES;
    }else
    {
        self.showBtn.hidden=NO;
    }
    CGRect frame=self.frame;
    if (model.isShow) {
       
        frame.size.height=model.showHeight;
        self.miaomuPinZhongLab.numberOfLines=0;
    }else{

        frame.size.height=190;
        
        self.miaomuPinZhongLab.numberOfLines=1;
    }
    [self.hezuoBtn addTarget:self action:@selector(hezuoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([model.status isEqualToString:@"已结束"]) {
        frame.size.height+=40;
        self.yincanglineV.hidden=NO;
        self.hezuoBtn.hidden=NO;
        [self.loggV setImage:[UIImage imageNamed:@""]];
    }else{
        self.yincanglineV.hidden=YES;
         self.hezuoBtn.hidden=YES;
    }
    self.frame=frame;
    self.showBtn.selected=model.isShow;

    if ([model.status isEqualToString:@"报价中"]) {
        [self.loggV setImage:[UIImage imageNamed:@"zt报价中"]];
    }
    if ([model.status isEqualToString:@"已结束"]) {
        [self.loggV setImage:[UIImage imageNamed:@"zt已结束"]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)hezuoBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(hezuoXiangQingActinWithMode:)]) {
        [self.delegate hezuoXiangQingActinWithMode:self.model];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
