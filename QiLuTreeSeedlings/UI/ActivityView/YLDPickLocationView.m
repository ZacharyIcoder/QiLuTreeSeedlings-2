//
//  YLDPickLocationView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDPickLocationView.h"

#import "YLDPickSelectVIew.h"
#import "UIDefines.h"
#define kActionVTag 19999
@interface YLDPickLocationView()<YLDPickSelectVIewDelegate>
@property(nonatomic,strong) CityModel *model;
@property (nonatomic,weak) YLDPickSelectVIew *shengV;
@property (nonatomic,weak) YLDPickSelectVIew *shiV;
@property (nonatomic,weak) YLDPickSelectVIew *xianV;
@property (nonatomic,weak) YLDPickSelectVIew *zhenV;
@property (nonatomic,weak) UILabel *shengL;
@property (nonatomic,weak) UILabel *shiL;
@property (nonatomic,weak) UILabel *xianL;
@property (nonatomic,weak) UILabel *zhenL;
@property (nonatomic,strong) CityModel *sheng;
@property (nonatomic,strong) CityModel *shi;
@property (nonatomic,strong) CityModel *xian;
@property (nonatomic,strong) CityModel *zhen;
@end
@implementation YLDPickLocationView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(kWidth*0.2, 0, kWidth*0.8, 64)];
        [backView setBackgroundColor:kRGB(210, 210, 210, 1)];
        [self addSubview:backView];
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 7+20, 30, 30)];
        [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
        
        [backView addSubview:backBtn];
        
        UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.8-70, 20, 60, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:sureBtn];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-50, 10+20, 100, 24)];
        titleLab.text=@"请选择地区";
        [titleLab setTextColor:titleLabColor];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:titleLab];

        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        
        UIView *titleview=[[UIView alloc]initWithFrame:CGRectMake(kWidth*0.2, 64, kWidth*0.8,40)];
        [titleview setBackgroundColor:BGColor];
        [self addSubview:titleview];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 20)];
        [lab1 setTextColor:titleLabColor];
        _shengL=lab1;
        [lab1 setFont:[UIFont systemFontOfSize:14]];
        [titleview addSubview:lab1];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 60, 20)];
        [lab2 setTextColor:titleLabColor];
        [lab2 setFont:[UIFont systemFontOfSize:14]];
        _shiL=lab2;
        [titleview addSubview:lab2];
        UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, 60, 20)];
        [lab3 setTextColor:titleLabColor];
        [lab3 setFont:[UIFont systemFontOfSize:14]];
        _xianL=lab3;
        [titleview addSubview:lab3];
        
        UILabel *lab4=[[UILabel alloc]initWithFrame:CGRectMake(190, 10, 60, 20)];
        [lab4 setTextColor:titleLabColor];
        [lab4 setFont:[UIFont systemFontOfSize:14]];
        _zhenL=lab4;
        [titleview addSubview:lab4];
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth*0.2, 104, kWidth*0.8, kHeight-104) andCode:nil andLeve:@"1"];
        _shengV=yldpickLV;
        yldpickLV.tag=111;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
    }
    return self;
}
-(void)sureBtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate selectSheng:_sheng shi:_shi xian:_xian zhen:_zhen];
    }
    [UIView animateWithDuration:0.22 animations:^{
        CGRect frame=self.frame;
        frame.origin.x=kWidth;
        self.frame=frame;
    } completion:^(BOOL finished) {
        [self removePickView];
    }];
}
-(void)selectWithCtiyModel:(CityModel *)model andYLDPickSelectVIew:(YLDPickSelectVIew *)pickSelectVIew
{
    if (pickSelectVIew.tag==111) {
        _shengL.text=model.cityName;
        _shiL.text=nil;
        _xianL.text=nil;
        _zhenL.text=nil;
        _sheng=model;
        _shi=nil;
        _xian=nil;
        _zhen=nil;
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
      
        _shiV=yldpickLV;
        yldpickLV.tag=112;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=yldpickLV.frame;
            frame.origin.x=kWidth*0.2;
            yldpickLV.frame=frame;
        }];
        return;
    }
    if (pickSelectVIew.tag==112) {
        _shiL.text=model.cityName;
        _xianL.text=nil;
        _zhenL.text=nil;
        _shi=model;
        _xian=nil;
        _zhen=nil;
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
        _xianV=yldpickLV;
        yldpickLV.tag=113;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=yldpickLV.frame;
            frame.origin.x=kWidth*0.2;
            yldpickLV.frame=frame;
        }];
        return;
    }
    if (pickSelectVIew.tag==113) {
        _xianL.text=model.cityName;
        _zhenL.text=nil;
        _xian=model;
        _zhen=nil;
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
        _zhenV=yldpickLV;
        yldpickLV.tag=114;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=yldpickLV.frame;
            frame.origin.x=kWidth*0.2;
            yldpickLV.frame=frame;
        }];
        return;
    }
    if (pickSelectVIew.tag==114) {
        _zhenL.text=model.cityName;
        _zhen=model;
        return;
    }
}
-(void)backBtn:(UIButton *)sender
{
    if (_zhenV) {
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=_zhenV.frame;
            frame.origin.x=kWidth;
            _zhenV.frame=frame;
        } completion:^(BOOL finished) {
            [_zhenV removeFromSuperview];
            _zhenV=nil;
        }];
        
        
        return;
    }
    if (_xianV) {
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=_xianV.frame;
            frame.origin.x=kWidth;
            _xianV.frame=frame;
        } completion:^(BOOL finished) {
            [_xianV removeFromSuperview];
            _xianV=nil;

        }];
        return;
    }
    if (_shiV) {
        [UIView animateWithDuration:0.22 animations:^{
            CGRect frame=_shiV.frame;
            frame.origin.x=kWidth;
            _shiV.frame=frame;
        } completion:^(BOOL finished) {
            [_shiV removeFromSuperview];
            _shiV=nil;
        }];
       
        return;
    }
    [UIView animateWithDuration:0.22 animations:^{
        CGRect frame=self.frame;
        frame.origin.x=kWidth;
        self.frame=frame;
    } completion:^(BOOL finished) {
         [self removePickView];
    }];

   
}
-(void)showPickView
{
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}
-(void)removePickView
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
