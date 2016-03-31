//
//  SellSearchTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellSearchTableViewCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@interface SellSearchTableViewCell()
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *numLab;
@end
@implementation SellSearchTableViewCell
@synthesize imageV,titleLab,cityLab,timeLab,numLab,priceLab;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
      [self setAccessibilityIdentifier:@"SellSearchTableViewCell1"];
        imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 80, frame.size.height-30)];
        [imageV setBackgroundColor:[UIColor redColor]];
        [self addSubview:imageV];
        titleLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 15, frame.size.width-100, 20)];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [titleLab setText:@"标题"];
        [self addSubview:titleLab];
        UIImageView *dingweiImageV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 42, 15, 15)];
        [dingweiImageV setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImageV];
        cityLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 40, 100, 20)];
        [cityLab setFont:[UIFont systemFontOfSize:15]];
        cityLab.text=@"山东 临沂";
        [self addSubview:cityLab];
        UIImageView *timeImagV=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+95, 42, 15, 15)];
        [timeImagV setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:timeImagV];
        timeLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+15+95, 40, 50, 20)];
        [timeLab setFont:[UIFont systemFontOfSize:15]];
        timeLab.text=@"今天";
        [self addSubview:timeLab];
        UIImageView *numImage=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+95, 72, 15, 15)];
        [numImage setImage:[UIImage imageNamed:@"LISTtreeNumber"]];
        [self addSubview:numImage];
        numLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.15+20+95, 70, 60, 20)];
        [numLab setFont:[UIFont systemFontOfSize:15]];
        numLab.text=@"599棵";
        [self addSubview:numLab];
        UILabel *shangcheLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65-10+80, 70, 50, 20)];
        [shangcheLab setFont:[UIFont systemFontOfSize:15]];
        shangcheLab.text=@"上车价";
        [self addSubview:shangcheLab];
        priceLab=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-80)*0.65+25+95, 70, 50, 20)];
        [priceLab setFont:[UIFont systemFontOfSize:13]];
        priceLab.text=@"50";
        [self addSubview:priceLab];
        
        UIImageView *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        [lineImageV setBackgroundColor:kLineColor];
        [self addSubview:lineImageV];

    }
    return self;
}
+(NSString *)IDStr
{
    return @"SellSearchTableViewCell1";
}
-(void)setHotSellModel:(HotSellModel *)hotSellModel
{
    _hotSellModel=hotSellModel;
    [self.imageV setImageWithURL:[NSURL URLWithString:hotSellModel.iamge] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.priceLab.text=hotSellModel.price;
    self.titleLab.text=hotSellModel.title;
    self.numLab.text=hotSellModel.count;
    self.cityLab.text=hotSellModel.area;
    self.timeLab.text=  hotSellModel.timeAger;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
