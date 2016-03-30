//
//  HotBuyViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotBuyViewCell.h"
#import "UIDefines.h"
@implementation HotBuyViewCell
-(id)initWithFrame:(CGRect)frame andDic:(HotBuyModel*)model
{
    self=[super initWithFrame:frame];
    if (self) {
        self.actionBtn=[[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:self.actionBtn];
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, frame.size.width-60, 13)];
        [self.titleLab setFont:[UIFont systemFontOfSize:12]];
        [self.titleLab setText:@"标题"];
        [self.titleLab setTextColor:[UIColor blackColor]];
        [self addSubview:self.titleLab];
        self.titleLab.text=model.title;
        UIImageView *dingweiImage=[[UIImageView alloc]initWithFrame:CGRectMake(35, 35, 13, 13)];
        [dingweiImage setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImage];
        self.cityLab=[[UILabel alloc]initWithFrame:CGRectMake(50, 35, 40, 12)];
        [self.cityLab setFont:[UIFont systemFontOfSize:10]];
        [self.cityLab setTextColor:[UIColor lightGrayColor]];
        [self.cityLab setText:@"临沂"];
        [self.cityLab setText:model.area];
        [self addSubview:self.cityLab];
        UIImageView * timeImag=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5-25,35,13,13)];
        [timeImag setImage:[UIImage imageNamed:@"listtime"]];
         [self addSubview:timeImag];
        self.timelLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5, 35, 50, 12)];
        [self.timelLab setFont:[UIFont systemFontOfSize:11]];
         [self.timelLab setTextColor:[UIColor lightGrayColor]];
        //[self.timelLab setText:@"N天前"];
        [self addSubview:self.timelLab];
        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.8-25, 35, 30, 13)];
        [priceLab setFont:[UIFont systemFontOfSize:11]];
        [priceLab setText:@"价格"];
          [priceLab setTextColor:[UIColor lightGrayColor]];
        [self addSubview:priceLab];
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.9-25, 35, 45, 15)];
        [self.priceLab setFont:[UIFont systemFontOfSize:14]];
         [self.priceLab setText:@"O元"];
        NSArray *timeAry=[model.creatTime componentsSeparatedByString:@" "];
        NSString *time1Str=[timeAry firstObject];
        NSArray *timeAry2=[time1Str componentsSeparatedByString:@"-"];
         
         if (timeAry2.count==3) {
             self.timelLab.text=[NSString stringWithFormat:@"%@月%@日",timeAry2[1],timeAry2[2]];
         }
         NSArray *priceAry=[model.price componentsSeparatedByString:@"."];
         self.priceLab.text=[priceAry firstObject];
       
        [self addSubview:self.priceLab];
          [self.priceLab setTextColor:[UIColor lightGrayColor]];
        UIImageView *imageVLine=[[UIImageView alloc]initWithFrame:CGRectMake(13, self.frame.size.height-0.5, self.frame.size.width-26, 0.5)];
        [imageVLine setBackgroundColor:kLineColor];
        [self addSubview:imageVLine];
    }
    return self;
}
-(void)setModel:(HotBuyModel *)model
{
    _model=model;
    self.titleLab.text=model.title;
    self.cityLab.text=model.area;
    NSArray *timeAry=[model.creatTime componentsSeparatedByString:@" "];
    NSString *time1Str=[timeAry firstObject];
    NSArray *timeAry2=[time1Str componentsSeparatedByString:@"-"];
    
    if (timeAry2.count==3) {
        self.timelLab.text=[NSString stringWithFormat:@"%@月%@日",timeAry2[1],timeAry2[2]];
    }
    NSArray *priceAry=[model.price componentsSeparatedByString:@"."];
    self.priceLab.text=[priceAry firstObject];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
