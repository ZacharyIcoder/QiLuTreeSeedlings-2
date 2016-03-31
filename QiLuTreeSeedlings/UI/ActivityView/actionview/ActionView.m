//
//  ActionView.m
//  YLDNav
//
//  Created by baba88 on 15/8/4.
//  Copyright (c) 2015年 MAC-02. All rights reserved.
//

#import "ActionView.h"
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kActionVTag 17777
@implementation ActionView
+(void)addActionView
{  ActionView *actionBV=[[ActionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [actionBV setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    UIImageView *actionView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-75, kHeight/2-80, 150, 150)];
    if (kWidth>320) {
        actionView.frame=CGRectMake(kWidth/2-30, kHeight/2-60, 60, 60);
    }else
    {
        actionView.frame=CGRectMake(kWidth/2-25, kHeight/2-35, 50, 50);
    }
    actionView.animationImages=[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"loading01"],
                                [UIImage imageNamed:@"loading02"],
                                [UIImage imageNamed:@"loading03"],
                                [UIImage imageNamed:@"loading04"],
                                [UIImage imageNamed:@"loading05"],
                                [UIImage imageNamed:@"loading06"],
                                [UIImage imageNamed:@"loading07"],
                                [UIImage imageNamed:@"loading08"],
                                nil];
    actionBV.tag=kActionVTag;
    actionView.animationDuration=0.5;
    actionView.animationRepeatCount=0;
    [actionView startAnimating];
    actionView.tag=1;
    actionBV.userInteractionEnabled=YES;
    [actionBV addSubview:actionView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
}
+(void)removeActionView
{
    NSArray *subViews = [[UIApplication sharedApplication] keyWindow].subviews;
    for (id object in subViews) {
        if ([[object class] isSubclassOfClass:[UIView class]]) {
            UIView *actionBView = (UIView *)object;
            if(actionBView.tag == kActionVTag)
            {
                UIImageView *imageView=(UIImageView *)[actionBView viewWithTag:1];
                imageView.animationRepeatCount=1;
                [imageView stopAnimating];
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
