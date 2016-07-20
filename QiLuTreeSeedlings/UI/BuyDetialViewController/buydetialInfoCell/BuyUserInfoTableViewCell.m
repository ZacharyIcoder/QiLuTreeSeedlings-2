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
@property (nonatomic,strong)UILabel *shenfenLab;
@property (nonatomic,strong)UIImageView *logoImageV;
@end
@implementation BuyUserInfoTableViewCell
@synthesize shenfenLab,logoImageV;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
        [iamgeV setImage:[UIImage imageNamed:@"qiugouxiangqingye"]];
        [self addSubview:iamgeV];
        iamgeV.layer.masksToBounds=YES;
        iamgeV.layer.cornerRadius=35;
        
        
        UIImageView *logoImageVx=[[UIImageView alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(iamgeV.frame)+5, 20, 20)];
        self.logoImageV=logoImageVx;
        [self addSubview:logoImageVx];
        
        UILabel *shenfenLabx=[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(iamgeV.frame)+5, 200, 20)];
        [shenfenLabx setFont:[UIFont systemFontOfSize:15]];
        [shenfenLabx setTextColor:NavYellowColor];
        self.shenfenLab=shenfenLabx;
        [self addSubview:shenfenLabx];
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
-(void)setModel:(BuyDetialModel *)model
{
    _model=model;
    self.nameLab.text=model.supplybuyName;
    NSString *nubStr=model.count;
    self.numLab.text =[NSString stringWithFormat:@"%@棵",nubStr];
    self.priceLab.text=model.price;
        if (model.goldsupplier == 0 || model.goldsupplier == 10) {
            CGRect frame=logoImageV.frame;
            frame.size.height=1;
            logoImageV.frame=frame;
        } else if (model.goldsupplier == 1) {
            shenfenLab.text=@"金牌供应商";
            logoImageV.image = [UIImage imageNamed:@"列表-金牌供应商"];
        } else if (model.goldsupplier == 2) {
            shenfenLab.text=@"银牌供应商";
            logoImageV.image = [UIImage imageNamed:@"列表-银牌供应商"];
        } else if (model.goldsupplier == 3) {
            shenfenLab.text=@"铜牌供应商";
            logoImageV.image = [UIImage imageNamed:@"列表-铜牌牌供应商"];
        } else if (model.goldsupplier == 4) {
            shenfenLab.text=@"认证供应商";
            logoImageV.image = [UIImage imageNamed:@"列表-认证供应商"];
        } else if (model.goldsupplier == 5) {
            shenfenLab.text=@"工作站总站";
            logoImageV.image = [UIImage imageNamed:@"列表-总站"];
        } else if (model.goldsupplier == 6) {
            shenfenLab.text=@"工作站分站";
            logoImageV.image = [UIImage imageNamed:@"列表-分站"];
        } else if (model.goldsupplier == 7) {
            shenfenLab.text=@"工程公司";
            logoImageV.image = [UIImage imageNamed:@"列表-工程公司"];
        }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
