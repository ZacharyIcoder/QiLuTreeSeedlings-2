//
//  HotSellViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotSellViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIDefines.h"
@interface HotSellViewCell ()
@property (nonatomic,strong) UIImageView *bigImageV;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *numLab;
@property (nonatomic,strong) UILabel *priceLab;

@end
@implementation HotSellViewCell
-(id)initWithFrame:(CGRect)frame andDic:(HotSellModel *)Model
{
    self=[super initWithFrame:frame];
    if (self) {
       // self.model=Model;
        self.actionBtn=[[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:self.actionBtn];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 80, frame.size.height-30)];
        self.bigImageV=imageV;
        [imageV setImageWithURL:[NSURL URLWithString:Model.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        [self addSubview:imageV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 15, frame.size.width-100, 20)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        self.titleLab=titleLab;
        [titleLab setText:Model.title];
        [self addSubview:titleLab];
        UIImageView *dingweiImageV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 43, 13, 13)];
        [dingweiImageV setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImageV];
        UILabel *cityLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 40, 100, 20)];
        [cityLab setFont:[UIFont systemFontOfSize:14]];
        self.cityLab =cityLab;
          [cityLab setTextColor:detialLabColor];
        cityLab.text=Model.area;
        [self addSubview:cityLab];
        UIImageView *timeImagV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.60+85, 43, 13, 13)];
        [timeImagV setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:timeImagV];
        UILabel *timeLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.60+20/320.f*kWidth+85, 40, 70, 20)];
        [timeLab setFont:[UIFont systemFontOfSize:14]];
          [timeLab setTextColor:detialLabColor];
        self.timeLab=timeLab;
        timeLab.text=@"今天";
        [self addSubview:timeLab];
        UIImageView *numImage=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 75, 13, 13)];
        [numImage setImage:[UIImage imageNamed:@"LISTtreeNumber"]];
        [self addSubview:numImage];
        UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 70, 90, 20)];
        [numLab setFont:[UIFont systemFontOfSize:14]];
          [numLab setTextColor:detialLabColor];
        numLab.text=@"599棵(株)";
        self.numLab=numLab;
        [self addSubview:numLab];
        UILabel *shangcheLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65-10+75, 70, 50, 20)];
        [shangcheLab setFont:[UIFont systemFontOfSize:14]];
        shangcheLab.text=@"上车价";
          [shangcheLab setTextColor:detialLabColor];
        [self addSubview:shangcheLab];
        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+80+30/320.f*kWidth, 68, 50, 20)];
        [priceLab setTextColor:[UIColor orangeColor]];
//        [timeLab setFont:[UIFont systemFontOfSize:15]];
//        priceLab.text=@"50";
        [priceLab setTextAlignment:NSTextAlignmentLeft];
        self.priceLab=priceLab;
        [self addSubview:priceLab];
        UIImageView *lineV=[[UIImageView alloc]initWithFrame:CGRectMake(13, self.frame.size.height, self.frame.size.width-26, 0.5)];
        [lineV setBackgroundColor:kLineColor];
        self.numLab.text=[NSString stringWithFormat:@"%@ 棵(株)",Model.count];
        
                    self.timeLab.text=Model.timeAger;
        
        NSArray *priceAry=[Model.price componentsSeparatedByString:@"."];
        self.priceLab.text=[priceAry firstObject];
        [self addSubview:lineV];
    }
    return self;
}
-(void)setModel:(HotSellModel *)model
{
    _model=model;
     [self.bigImageV setImageWithURL:[NSURL URLWithString:model.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.titleLab.text=model.title;
    self.numLab.text=[NSString stringWithFormat:@"%@ 棵(株)",model.count];
    self.timeLab.text=model.timeAger;
    NSArray *priceAry=[model.price componentsSeparatedByString:@"."];
    self.priceLab.text=[priceAry firstObject];
    self.cityLab.text=model.area;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
