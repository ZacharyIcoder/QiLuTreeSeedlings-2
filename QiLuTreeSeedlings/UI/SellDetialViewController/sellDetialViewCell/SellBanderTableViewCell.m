//
//  SellBanderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellBanderTableViewCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@interface SellBanderTableViewCell ()

@end
@implementation SellBanderTableViewCell

-(id)initWithFrame:(CGRect)frame andModel:(SupplyDetialMode*)model andHotSellModel:(HotSellModel *)hotModel
{
    self=[super initWithFrame:frame];
    if ( self) {
        NSArray *imagAry=model.images;
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 210)];
        [self addSubview:scrollView];
        [scrollView setContentSize:CGSizeMake(kWidth*imagAry.count,0)];
        scrollView.pagingEnabled=YES;
        for (int i=0; i<imagAry.count ; i++) {
            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, 210)];
            [imageV setImageWithURL:[NSURL URLWithString:imagAry[i]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
            [scrollView addSubview:imageV];
        }
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,210-20, kWidth,20)];
        [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:view];
        UIImageView *dingweiImageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 15, 15)];
        [view addSubview:dingweiImageV];
        [dingweiImageV setImage:[UIImage imageNamed:@"region"]];
        if (hotModel.area.length==0) {
            dingweiImageV.hidden=YES;
        }
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 80, 20)];
        [lab setFont:[UIFont systemFontOfSize:12]];
        lab.text=hotModel.area;
        [lab setTextColor:[UIColor whiteColor]];
        [view addSubview:lab];
        UILabel *liulanLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-60, 0, 40, 20)];
        [liulanLab setFont:[UIFont systemFontOfSize:12]];
        [liulanLab setTextAlignment:NSTextAlignmentRight];
        [view addSubview:liulanLab];
        liulanLab.text=[NSString stringWithFormat:@"%@次",model.views];
        [liulanLab setTextColor:[UIColor whiteColor]];
        UIImageView *viewsImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-80, 3, 15, 14)];
        [viewsImageV setImage:[UIImage imageNamed:@"viewsNum"]];
        [view addSubview:viewsImageV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(18, 215, kWidth-18*2, 20)];
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        //[titleLab setTextColor:[UIColor lightGrayColor]];
        titleLab.text=hotModel.title;
        [self addSubview:titleLab];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab.frame)+5, kWidth-40, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
        UIView *userView=[self viewWithTitle:model.supplybuyName andX:(kWidth-150)/4.f andColor:[UIColor blackColor] andImageName:@"person"];
        [self addSubview:userView];
        UIView *numView=[self viewWithTitle:[NSString stringWithFormat:@"%@棵",model.count] andX:kWidth/2-25 andColor:titleLabColor andImageName:@"LISTtreeNumber"];
        [self addSubview:numView];
        
        UIView *priceView=[self viewWithTitle:[NSString stringWithFormat:@"%@元/棵",model.price] andX:kWidth-(kWidth-150)/4.f-50 andColor:[UIColor orangeColor] andImageName:@"price"];
        [self addSubview:priceView];
    }
    return self;
}
-(UIView *)viewWithTitle:(NSString *)title andX:(CGFloat)x andColor:(UIColor *)color andImageName:(NSString *)imgeName
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(x, 250, 50, 70)];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 40, 40)];
    [view addSubview:imageV];
    [imageV setImage:[UIImage imageNamed:imgeName]];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(-25, 40, 100, 30)];
    titleLab.text=title;
    //titleLab.numberOfLines=2;
    //[titleLab sizeToFit];t
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:titleLab];
    return view;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
