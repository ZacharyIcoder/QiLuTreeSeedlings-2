//
//  BuyMessageAlertView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyMessageAlertView.h"
//#define kLineColor       [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]
#define yellowButtonColor kRGB(255, 152, 31, 1)
#define titleLabColor kRGB(102, 102, 102, 1)
#define detialLabColor kRGB(153, 153, 153, 1)
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kActionVTag 188888
#define BotHeight 190
@implementation BuyMessageAlertView
+(BuyMessageAlertView *)addActionVieWithPrice:(NSString *)price AndMone:(NSString *)yue
{  BuyMessageAlertView *actionBV=[[BuyMessageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    actionBV.tag=kActionVTag;
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    UIView *bottowView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, BotHeight)];
    [bottowView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, kWidth-30, 60)];
    lable.numberOfLines=0;
    lable.text=@"本求购信息已由工作人员审核检验，但您购买时不排除客户已找到货源，请确认是否购买，购买后请第一时间联系买方。";
    [lable setTextColor:detialLabColor];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [bottowView addSubview:lable];
    NSString *contentStr = [NSString stringWithFormat:@"所需费用%@元（当前余额：%@元）",price,yue];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:yellowButtonColor range:NSMakeRange(4, price.length+1)];
    [str addAttribute:NSForegroundColorAttributeName value:yellowButtonColor range:NSMakeRange(11+price.length, yue.length+1)];
    UILabel *labss=[[UILabel alloc]initWithFrame:CGRectMake(20, 90, kWidth-40, 20)];
    [labss setTextAlignment:NSTextAlignmentCenter];
    [labss setTextColor:detialLabColor];
    [labss setFont:[UIFont systemFontOfSize:14]];
    labss.attributedText=str;
    [bottowView addSubview:labss];
    
    UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 0.5)];
    [imageV1 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV1];
    UIImageView *imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-45, 0.5, 40)];
    [imageV2 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV2];

    [actionBV addSubview:bottowView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActionView)];
    [actionBV addGestureRecognizer:tapGesture];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth/2, 50)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    actionBV.leftBtn=leftBtn;
    [bottowView addSubview:leftBtn];
    [leftBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(removeActionView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-50, kWidth/2, 50)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    actionBV.rightBtn=rightBtn;
    [bottowView addSubview:rightBtn];
    [rightBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame=bottowView.frame;
        frame.origin.y=kHeight -BotHeight;
        bottowView.frame=frame;
    }];
    
    return actionBV;
}

+(BuyMessageAlertView *)addActionViewWithTitle:(NSString *)title andDetail:(NSString *)detail {
    BuyMessageAlertView *actionBV=[[BuyMessageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    actionBV.tag=kActionVTag;
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    UIView *bottowView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, BotHeight)];
    [bottowView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, kWidth-30, 60)];
    lable.numberOfLines=0;
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    [lable setTextColor:detialLabColor];
    [lable setFont:[UIFont systemFontOfSize:16]];
    [bottowView addSubview:lable];
    UILabel *labss=[[UILabel alloc]initWithFrame:CGRectMake(20, 80, kWidth-40, 20)];
    [labss setTextAlignment:NSTextAlignmentCenter];
    [labss setTextColor:detialLabColor];
    [labss setFont:[UIFont systemFontOfSize:16]];
    labss.text = detail;
    [bottowView addSubview:labss];

    UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 0.5)];
    [imageV1 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV1];
    UIImageView *imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-45, 0.5, 40)];
    [imageV2 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV2];

    [actionBV addSubview:bottowView];

    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActionView)];
    [actionBV addGestureRecognizer:tapGesture];

    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth/2, 50)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    actionBV.leftBtn=leftBtn;
    [bottowView addSubview:leftBtn];
    [leftBtn setTitleColor:detialLabColor forState:UIControlStateNormal];

    [leftBtn addTarget:self action:@selector(removeActionView) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-50, kWidth/2, 50)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    actionBV.rightBtn=rightBtn;
    [bottowView addSubview:rightBtn];
    [rightBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame=bottowView.frame;
        frame.origin.y=kHeight -BotHeight;
        bottowView.frame=frame;
    }];

    return actionBV;

}

+(BuyMessageAlertView *)addActionVieWithReturnReason:(NSString *)reason
{
    BuyMessageAlertView *actionBV=[[BuyMessageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    actionBV.tag=kActionVTag;
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    UIView *bottowView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, BotHeight)];
    [bottowView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, kWidth-30, 20)];
    lable.numberOfLines=0;
    lable.text=@"退回原因";
    [lable setTextColor:titleLabColor];
    [lable setFont:[UIFont systemFontOfSize:16]];
    [bottowView addSubview:lable];
    
    UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 0.5)];
    [imageV1 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, kWidth-20, BotHeight-50-50)];
    lab2.numberOfLines=0;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=reason;
    [lab2 setTextColor:detialLabColor];
    [lab2 setFont:[UIFont systemFontOfSize:16]];
    [bottowView addSubview:lab2];
    UIImageView *imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 0.5)];
    [imageV2 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV2];
    
    UIImageView *imageV3=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-45, 0.5, 40)];
    [imageV3 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV3];

    [actionBV addSubview:bottowView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActionView)];
    [actionBV addGestureRecognizer:tapGesture];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth/2, 50)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    actionBV.leftBtn=leftBtn;
    [bottowView addSubview:leftBtn];
    [leftBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    
   [leftBtn addTarget:self action:@selector(removeActionView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-50, kWidth/2, 50)];
    [rightBtn setTitle:@"立即编辑" forState:UIControlStateNormal];
    actionBV.rightBtn=rightBtn;
    [bottowView addSubview:rightBtn];
    [rightBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame=bottowView.frame;
        frame.origin.y=kHeight -BotHeight;
        bottowView.frame=frame;
    }];
    
    return actionBV;
}
+(BuyMessageAlertView *)addActionViewshuxin
{
    BuyMessageAlertView *actionBV=[[BuyMessageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    actionBV.tag=kActionVTag;
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    UIView *bottowView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, BotHeight)];
    [bottowView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, kWidth-20, BotHeight-50-50)];
    lab2.numberOfLines=0;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"确认刷新所选内容？";
    [lab2 setTextColor:detialLabColor];
    [lab2 setFont:[UIFont systemFontOfSize:16]];
    [bottowView addSubview:lab2];
    UIImageView *imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 0.5)];
    [imageV2 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV2];
    
    UIImageView *imageV3=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-45, 0.5, 40)];
    [imageV3 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV3];
    
    [actionBV addSubview:bottowView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActionView)];
    [actionBV addGestureRecognizer:tapGesture];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth/2, 50)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    actionBV.leftBtn=leftBtn;
    [bottowView addSubview:leftBtn];
    [leftBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(removeActionView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, BotHeight-50, kWidth/2, 50)];
    [rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
    actionBV.rightBtn=rightBtn;
    [bottowView addSubview:rightBtn];
    [rightBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame=bottowView.frame;
        frame.origin.y=kHeight -BotHeight;
        bottowView.frame=frame;
    }];
    
    return actionBV;
}
+(BuyMessageAlertView *)addActionViewMiaoPuWanShan
{
    BuyMessageAlertView *actionBV=[[BuyMessageAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    actionBV.tag=kActionVTag;
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    UIView *bottowView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, BotHeight)];
    [bottowView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80, 10, 160, 40)];
    lab2.numberOfLines=0;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"您还没有完善苗圃信息，不能发布供应和求购信息！";
    [lab2 setTextColor:titleLabColor];
    [lab2 setFont:[UIFont systemFontOfSize:13]];
    [bottowView addSubview:lab2];
    UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-15, 55, 40, 40)];
    [imageV1 setImage:[UIImage imageNamed:@"wanshanmiaopo"]];
    [bottowView addSubview:imageV1];
    UIImageView *imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 0.5)];
    [imageV2 setBackgroundColor:kLineColor];
    [bottowView addSubview:imageV2];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80, 100, 160, 40)];
    messageLab.textAlignment=NSTextAlignmentCenter;
    messageLab.text=@"完善苗圃信息";
    [messageLab setTextColor:titleLabColor];
    [messageLab setFont:[UIFont systemFontOfSize:14]];
    [bottowView addSubview:messageLab];
    [actionBV addSubview:bottowView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeActionView)];
    [actionBV addGestureRecognizer:tapGesture];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, BotHeight-50, kWidth, 50)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    actionBV.leftBtn=leftBtn;
    [bottowView addSubview:leftBtn];
    [leftBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(removeActionView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 50, kWidth/2, BotHeight-50-50)];
    actionBV.rightBtn=rightBtn;
    [bottowView addSubview:rightBtn];
    [rightBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame=bottowView.frame;
        frame.origin.y=kHeight -BotHeight;
        bottowView.frame=frame;
    }];
    
    return actionBV;
}
+(void)removeActionView
{
    NSArray *subViews = [[UIApplication sharedApplication] keyWindow].subviews;
    for (id object in subViews) {
        if ([[object class] isSubclassOfClass:[UIView class]]) {
            UIView *actionBView = (UIView *)object;
            if(actionBView.tag == kActionVTag)
            {
//                UIImageView *imageView=(UIImageView *)[actionBView viewWithTag:1];
//                imageView.animationRepeatCount=1;
//                [imageView stopAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    actionBView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [actionBView removeFromSuperview];
                }];
                
            }
        }
    }
}
@end
