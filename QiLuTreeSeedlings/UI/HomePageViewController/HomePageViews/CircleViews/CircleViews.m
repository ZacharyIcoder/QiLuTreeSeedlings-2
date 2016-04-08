//
//  CircleViews.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CircleViews.h"
@interface CircleViews ()
@property (nonatomic,strong) NSArray *dataAry;
@end
@implementation CircleViews
@synthesize dataAry;
-(id)initWithFrame:(CGRect)frame
{
    
    
    self=[super initWithFrame:frame];
    if (self) {
        dataAry =@[@"供应信息",@"求购信息",@"我的收藏",@"信息定制"];
        NSArray *imageAry=@[@"NomerSellMessageBtn",@"NomerBuyMessageBtn",@"NomerMyCollectionBtn",@"NomerCustomBtn"];
        [self setBackgroundColor:[UIColor whiteColor]];
        for (int i=0; i<dataAry.count; i++) {
            
            UIView *circV=[self makeCircleViewWtihName:dataAry[i] WithImagName:imageAry[i] WithNum:i];
            [self addSubview:circV];
            
        }
    }
    return self;
}

-(UIView *)makeCircleViewWtihName:(NSString *)nameStr WithImagName:(NSString *)imagName WithNum:(int)i
{
    int CWith=self.frame.size.width/4;
    UIView *circleView=[[UIView alloc]initWithFrame:CGRectMake(i*CWith, 0, CWith, self.frame.size.height)];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(circleView.frame.size.width/2-43/2, self.frame.size.height/2-31, 43, 43)];
    [imageV setImage:[UIImage imageNamed:imagName]];
    imageV.layer.masksToBounds=YES;
    imageV.layer.cornerRadius=43/2;
    [circleView addSubview:imageV];
    UIButton *circBtn=[[UIButton alloc]initWithFrame:imageV.frame];
    circBtn.tag=i;
    [circBtn addTarget:self action:@selector(circleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [circleView addSubview:circBtn];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, CWith, 20)];
    nameLab.textAlignment=NSTextAlignmentCenter;
    nameLab.text=nameStr;
    [nameLab setTextColor:[UIColor darkGrayColor]];
    [nameLab setFont:[UIFont systemFontOfSize:13]];
    [circleView addSubview:nameLab];
    return circleView;
}

-(void)circleBtnAction:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    if (self.delegate) {
        [self.delegate circleViewsPush:sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
