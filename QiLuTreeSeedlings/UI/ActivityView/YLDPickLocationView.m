//
//  YLDPickLocationView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDPickLocationView.h"
#import "CityModel.h"
#import "YLDPickSelectVIew.h"
#import "UIDefines.h"
#define kActionVTag 19999
@interface YLDPickLocationView()<YLDPickSelectVIewDelegate>
@property(nonatomic,strong) CityModel *model;
@property (nonatomic,weak) YLDPickSelectVIew *shengV;
@property (nonatomic,weak) YLDPickSelectVIew *shiV;
@property (nonatomic,weak) YLDPickSelectVIew *xianV;
@property (nonatomic,weak) YLDPickSelectVIew *zhenV;
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
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-50, 10+20, 100, 24)];
        titleLab.text=@"请选择地区";
        [titleLab setTextColor:titleLabColor];
        titleLab.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:titleLab];

        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth*0.2, 104, kWidth*0.8, kHeight-104) andCode:nil andLeve:@"1"];
        _shengV=yldpickLV;
        yldpickLV.tag=111;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
    }
    return self;
}
-(void)selectWithCtiyModel:(CityModel *)model andYLDPickSelectVIew:(YLDPickSelectVIew *)pickSelectVIew
{
    if (pickSelectVIew.tag==111) {
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth*0.2, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
        _shiV=yldpickLV;
        yldpickLV.tag=112;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        return;
    }
    if (pickSelectVIew.tag==112) {
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth*0.2, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
        _xianV=yldpickLV;
        yldpickLV.tag=113;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        return;
    }
    if (pickSelectVIew.tag==113) {
        YLDPickSelectVIew *yldpickLV=[[YLDPickSelectVIew alloc]initWithFrame:CGRectMake(kWidth*0.2, 104, kWidth*0.8, kHeight-104) andCode:model.code andLeve:model.level];
        _zhenV=yldpickLV;
        yldpickLV.tag=114;
        yldpickLV.delegate=self;
        [self addSubview:yldpickLV];
        return;
    }
    if (pickSelectVIew.tag==114) {
        
        return;
    }
}
-(void)backBtn:(UIButton *)sender
{
    if (_zhenV) {
        [_zhenV removeFromSuperview];
        _zhenV=nil;
        return;
    }
    if (_xianV) {
        [_xianV removeFromSuperview];
        _xianV=nil;
        return;
    }
    if (_shiV) {
        [_shiV removeFromSuperview];
        _shiV=nil;
        return;
    }
    [self removePickView];
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
