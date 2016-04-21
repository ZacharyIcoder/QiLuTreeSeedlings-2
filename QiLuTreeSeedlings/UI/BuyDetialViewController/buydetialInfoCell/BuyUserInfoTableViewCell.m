//
//  BuyUserInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyUserInfoTableViewCell.h"
#import "UIDefines.h"

@interface BuyUserInfoTableViewCell()
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *numLab;
@property (nonatomic,strong)UILabel *priceLab;
@end
@implementation BuyUserInfoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
        [iamgeV setImage:[UIImage imageNamed:@"qiugouxiangqingye"]];
        [self addSubview:iamgeV];
        iamgeV.layer.masksToBounds=YES;
        iamgeV.layer.cornerRadius=35;
        UILabel *namezLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 17, 55, 20)];
        [namezLab setTextAlignment:NSTextAlignmentRight];
        [namezLab setTextColor:detialLabColor];
        [namezLab setFont:[UIFont systemFontOfSize:13]];
        [namezLab setText:@"求购商"];
        [self addSubview:namezLab];
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2+30, 17, 120, 20)];
        [self.nameLab setTextAlignment:NSTextAlignmentLeft];
        [self.nameLab setTextColor:titleLabColor];
        [self.nameLab setFont:[UIFont systemFontOfSize:13]];
        [self.nameLab setText:@"XXX"];
        [self addSubview:self.nameLab];
        
        UILabel *numebLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 40, 55, 20)];
        [numebLab setTextAlignment:NSTextAlignmentRight];
        [numebLab setTextColor:detialLabColor];
        [numebLab setFont:[UIFont systemFontOfSize:13]];
        [numebLab setText:@"数量"];
        [self addSubview:numebLab];
        self.numLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2+30, 40, 80, 20)];
        [self.numLab setTextAlignment:NSTextAlignmentLeft];
        [self.numLab setTextColor:titleLabColor];
        [self.numLab setFont:[UIFont systemFontOfSize:13]];
        [self.numLab setText:@"0棵"];
        [self addSubview:self.numLab];
        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 63, 55, 20)];
        [priceLab setTextAlignment:NSTextAlignmentRight];
        [priceLab setTextColor:detialLabColor];
        [priceLab setFont:[UIFont systemFontOfSize:13]];
        [priceLab setText:@"价格(元)"];
        [self addSubview:priceLab];
        
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2+30, 63, 80, 20)];
        [self.priceLab setTextAlignment:NSTextAlignmentLeft];
        [self.priceLab setTextColor:titleLabColor];
        [self.priceLab setFont:[UIFont systemFontOfSize:13]];
        [self.priceLab setText:@"面议"];
        [self addSubview:self.priceLab];
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
   // [self.imageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLab.text=[dic objectForKey:@"supplybuyName"];
    NSString *nubStr=[dic objectForKey:@"count"];
    self.numLab.text =[NSString stringWithFormat:@"%@棵",nubStr];
    self.priceLab.text=[dic objectForKey:@"price"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
