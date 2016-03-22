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
@implementation HotSellViewCell
-(id)initWithFrame:(CGRect)frame andDic:(HotSellModel *)Model
{
    self=[super initWithFrame:frame];
    if (self) {
        self.actionBtn=[[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:self.actionBtn];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 80, frame.size.height-30)];
        [imageV setImageWithURL:[NSURL URLWithString:Model.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        [self addSubview:imageV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 15, frame.size.width-100, 20)];
        [titleLab setTextColor:[UIColor blackColor]];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:Model.title];
        [self addSubview:titleLab];
        UIImageView *dingweiImageV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 45, 10, 10)];
        [dingweiImageV setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImageV];
        UILabel *cityLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 40, 100, 20)];
        [cityLab setFont:[UIFont systemFontOfSize:15]];
          [cityLab setTextColor:[UIColor lightGrayColor]];
        cityLab.text=Model.area;
        [self addSubview:cityLab];
        UIImageView *timeImagV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+95, 45, 10, 10)];
        [timeImagV setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:timeImagV];
        UILabel *timeLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+15+95, 40, 50, 20)];
        [timeLab setFont:[UIFont systemFontOfSize:15]];
          [timeLab setTextColor:[UIColor lightGrayColor]];
        timeLab.text=@"今天";
        [self addSubview:timeLab];
        UIImageView *numImage=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 75, 10, 10)];
        [numImage setImage:[UIImage imageNamed:@"LISTtreeNumber"]];
        [self addSubview:numImage];
        UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 70, 60, 20)];
        [numLab setFont:[UIFont systemFontOfSize:15]];
          [numLab setTextColor:[UIColor lightGrayColor]];
        numLab.text=@"599棵";
        [self addSubview:numLab];
        UILabel *shangcheLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65-10+80, 70, 50, 20)];
        [shangcheLab setFont:[UIFont systemFontOfSize:15]];
        shangcheLab.text=@"上车价";
          [shangcheLab setTextColor:[UIColor lightGrayColor]];
        [self addSubview:shangcheLab];
        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+25+95, 70, 50, 20)];
        [priceLab setTextColor:[UIColor orangeColor]];
//        [timeLab setFont:[UIFont systemFontOfSize:15]];
        priceLab.text=@"50";
        [self addSubview:priceLab];
        UIImageView *lineV=[[UIImageView alloc]initWithFrame:CGRectMake(13, self.frame.size.height, self.frame.size.width-26, 0.5)];
        [lineV setBackgroundColor:kLineColor];
        [self addSubview:lineV];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
