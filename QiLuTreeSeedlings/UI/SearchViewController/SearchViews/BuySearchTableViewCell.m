//
//  BuySearchTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuySearchTableViewCell.h"
#import "UIDefines.h"
@interface BuySearchTableViewCell()
//@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)UILabel *timeLab;
//@property (nonatomic,strong)UILabel *numLab;
@end
@implementation BuySearchTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setAccessibilityIdentifier:@"SellSearchTableViewCell2"];
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(18, 10, kWidth-20, 13)];
        [self.titleLab setFont:[UIFont systemFontOfSize:15]];
        [self.titleLab setText:@"标题"];
        [self addSubview:self.titleLab];
        UIImageView *dingweiImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 38, 15, 15)];
        [dingweiImage setImage:[UIImage imageNamed:@"region"]];
        [self addSubview:dingweiImage];
        self.cityLab=[[UILabel alloc]initWithFrame:CGRectMake(38, 40, 60, 12)];
        
        [self.cityLab setFont:[UIFont systemFontOfSize:12]];
        [self.cityLab setText:@"临沂"];
        [self.cityLab setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.cityLab];
        UIImageView * timeImag=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.5-45,38, 15, 15)];
         [timeImag setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:timeImag];
        self.timeLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.5-20, 40, 55, 12)];
         [self.timeLab setTextColor:[UIColor lightGrayColor]];
        [self.timeLab setFont:[UIFont systemFontOfSize:12]];
        [self.timeLab setText:@"N天前"];
        [self addSubview:self.timeLab];
        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.8-25, 40, 30, 12)];
        [priceLab setFont:[UIFont systemFontOfSize:12]];
        [priceLab setText:@"价格"];
        [self addSubview:priceLab];
         [priceLab setTextColor:[UIColor lightGrayColor]];
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.9-25, 35, 65, 20)];
        [self.priceLab setFont:[UIFont systemFontOfSize:18]];
        [self.priceLab setText:@"O元"];
        [self.priceLab setTextColor:[UIColor orangeColor]];
        [self addSubview:self.priceLab];
        UIImageView *imageVLine=[[UIImageView alloc]initWithFrame:CGRectMake(13, 69.5, kWidth-26, 0.5)];
        [imageVLine setBackgroundColor:kLineColor];
        [self addSubview:imageVLine];

    }
    return self;
}
+(NSString *)IDStr
{
    return @"SellSearchTableViewCell2";
}
-(void)setHotBuyModel:(HotBuyModel *)hotBuyModel
{
    _hotBuyModel=hotBuyModel;
    self.titleLab.text=hotBuyModel.title;
    self.cityLab.text=hotBuyModel.area;
   
        self.timeLab.text=hotBuyModel.timeAger;
   
    
    NSArray *priceAry=[hotBuyModel.price componentsSeparatedByString:@"."];
    self.priceLab.text=[priceAry firstObject];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
