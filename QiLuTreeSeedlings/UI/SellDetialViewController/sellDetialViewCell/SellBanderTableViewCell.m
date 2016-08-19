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
#import "SupplyDetialMode.h"
#import "HotSellModel.h"

@interface SellBanderTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIButton *leftBtn;
@property (nonatomic,weak) UIButton *rightBtn;
@property (nonatomic) NSInteger countNum;
@property (nonatomic,weak)UIScrollView *scrollView;
@end
@implementation SellBanderTableViewCell

-(id)initWithFrame:(CGRect)frame andModel:(SupplyDetialMode*)model andHotSellModel:(HotSellModel *)hotModel
{
    self=[super initWithFrame:frame];
    if ( self) {
        NSArray *imagAry=model.images;
        _countNum=imagAry.count;
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 210)];
        scrollView.delegate=self;
        self.scrollView=scrollView;
        [self addSubview:scrollView];
        [scrollView setContentSize:CGSizeMake(kWidth*imagAry.count,0)];
        scrollView.pagingEnabled=YES;
        for (int i=0; i<imagAry.count ; i++) {
            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, 210)];
            CGRect BTNFRAME=imageV.frame;
            UIButton *BTN=[[UIButton alloc]initWithFrame:BTNFRAME];
            BTN.tag=i;
            
            [BTN addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [imageV setImageWithURL:[NSURL URLWithString:imagAry[i]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
            [imageV setContentMode:UIViewContentModeScaleAspectFill];
            
            imageV.clipsToBounds = YES;
             [scrollView addSubview:BTN];
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
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 90, 20)];
        [lab setFont:[UIFont systemFontOfSize:12]];
        [lab setTextColor:titleLabColor];
        lab.text=hotModel.area;
        [lab setTextColor:[UIColor whiteColor]];
        [view addSubview:lab];
        UILabel *liulanLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-40, 3, 39, 14)];
        [liulanLab setFont:[UIFont systemFontOfSize:12]];
        [liulanLab setTextAlignment:NSTextAlignmentRight];
        [view addSubview:liulanLab];
        liulanLab.text=[NSString stringWithFormat:@"%@次",model.views];
        [liulanLab sizeToFit];
        [liulanLab setTextColor:[UIColor whiteColor]];
        UIImageView *viewsImageV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(liulanLab.frame)-30, 3, 15, 14)];
        [viewsImageV setImage:[UIImage imageNamed:@"viewsNum"]];
        [view addSubview:viewsImageV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(18, 217, kWidth-18*2, 20)];
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        [titleLab setTextColor:titleLabColor];
        titleLab.text=hotModel.title;
        [self addSubview:titleLab];
        
        UIImageView *logoImageV=[[UIImageView alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(titleLab.frame)+5, 20, 20)];
        [self addSubview:logoImageV];
        
        UILabel *shenfenLab=[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(titleLab.frame)+5, 200, 20)];
        [shenfenLab setFont:[UIFont systemFontOfSize:15]];
        [shenfenLab setTextColor:NavYellowColor];
        [self addSubview:shenfenLab];
        if (model.goldsupplier == 0 || model.goldsupplier == 10) {
            shenfenLab.text=@"普通供应商";
            logoImageV.image = [UIImage imageNamed:@"列表-普通供应商"];
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

        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(logoImageV.frame)+5, kWidth-40, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
        CGFloat yyy=CGRectGetMaxY(lineView.frame)+5;
        UIView *userView = nil;
        if (model.memberName) {
            userView=[self viewWithTitle:model.memberName andX:(kWidth-150)/4.f andY:yyy andColor:titleLabColor andImageName:@"person"];
        } else {
            userView=[self viewWithTitle:model.supplybuyName andX:(kWidth-150)/4.f andY:yyy andColor:titleLabColor andImageName:@"person"];
        }
//        UIView *userView=[self viewWithTitle:model.supplybuyName andX:(kWidth-150)/4.f andColor:titleLabColor andImageName:@"person"];
        [self addSubview:userView];
        UIView *numView=[self viewWithTitle:[NSString stringWithFormat:@"%@棵",model.count] andX:kWidth/2-25 andY:yyy andColor:titleLabColor andImageName:@"LISTtreeNumber"];
        [self addSubview:numView];
        NSString *priceStr;
        if ([model.price isEqualToString:@"面议"]) {
            priceStr=@"面议";
        }else
        {
            priceStr=[NSString stringWithFormat:@"%@元/棵",model.price];
        }
        UIView *priceView=[self viewWithTitle:priceStr andX:kWidth-(kWidth-150)/4.f-50 andY:yyy andColor:yellowButtonColor andImageName:@"price"];
        [self addSubview:priceView];
        
        UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, 210/2-25, 50, 50)];
        [rightBtn setImage:[UIImage imageNamed:@"rightBtnImage"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAcrion:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn=rightBtn;
        [self addSubview:rightBtn];
        
        UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 210/2-25, 50, 50)];
        [leftBtn setImage:[UIImage imageNamed:@"leftBtnImage"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn=leftBtn;
        [self addSubview:leftBtn];
        if (_countNum<=1) {
            scrollView.delegate=nil;
            leftBtn.hidden=YES;
            rightBtn.hidden=YES;
        }else{
            leftBtn.hidden=YES;
        }
    }
    return self;
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x==0) {
        self.leftBtn.hidden=YES;
        if (self.rightBtn.hidden==YES) {
            self.rightBtn.hidden=NO;
        }
        return;
    }else if (scrollView.contentOffset.x/kWidth==_countNum-1) {
        self.rightBtn.hidden=YES;
        if (self.leftBtn.hidden==YES) {
            self.leftBtn.hidden=NO;
        }
        return;
    }else
    {
        if (self.leftBtn.hidden==YES) {
            self.leftBtn.hidden=NO;
        }
        if (self.rightBtn.hidden==YES) {
            self.rightBtn.hidden=NO;
        }
    }

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x==0) {
        self.leftBtn.hidden=YES;
        if (self.rightBtn.hidden==YES) {
            self.rightBtn.hidden=NO;
        }
        return;
    }else if (scrollView.contentOffset.x/kWidth==_countNum-1) {
        self.rightBtn.hidden=YES;
        if (self.leftBtn.hidden==YES) {
            self.leftBtn.hidden=NO;
        }
        return;
    }else
    {
        if (self.leftBtn.hidden==YES) {
            self.leftBtn.hidden=NO;
        }
        if (self.rightBtn.hidden==YES) {
            self.rightBtn.hidden=NO;
        }
    }
}
-(void)leftBtnAction:(UIButton *)sender
{
    if (self.scrollView.contentOffset.x>0) {
        CGFloat x=self.scrollView.contentOffset.x-kWidth;
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        return;
    }
}
-(void)rightBtnAcrion:(UIButton *)sender
{
    if (self.scrollView.contentOffset.x<(self.scrollView.contentSize.width-kWidth)) {
        
        CGFloat x=self.scrollView.contentOffset.x+kWidth;
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        return;
    }
}
-(UIView *)viewWithTitle:(NSString *)title andX:(CGFloat)x andY:(CGFloat)y andColor:(UIColor *)color andImageName:(NSString *)imgeName
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(x, y, 50, 70)];
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
-(void)BtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate showBigImageWtihIndex:sender.tag];
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
