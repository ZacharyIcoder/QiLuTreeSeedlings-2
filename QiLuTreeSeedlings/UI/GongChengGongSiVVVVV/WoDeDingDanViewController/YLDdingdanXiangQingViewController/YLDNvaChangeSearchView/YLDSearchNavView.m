//
//  YLDSearchNavView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDSearchNavView.h"
#import "UIDefines.h"
@implementation YLDSearchNavView
-(id)init
{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(70, 0,kWidth-80 , 64);
        UIView *texeView=[[UIView alloc]initWithFrame:CGRectMake(5, 24, kWidth-100, 30)];
        [texeView setBackgroundColor:[UIColor whiteColor]];
        texeView.layer.masksToBounds=YES;
        texeView.layer.cornerRadius=5;
        [self addSubview:texeView];
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, 0, kWidth-160)];
        [texeView addSubview:textField];
        UIButton *hidingBtn=[[UIButton alloc]initWithFrame:CGRectMake(texeView.frame.size.width-40, 1.5, 27, 27)];
        [hidingBtn setImage:[UIImage imageNamed:@"searchOrange"] forState:UIControlStateNormal];
        [hidingBtn addTarget: self action:@selector(hidingSelf) forControlEvents:UIControlEventTouchUpInside];
        
        [texeView addSubview:hidingBtn];
    }
    return self;
}
-(void)hidingSelf
{
    self.hidden=YES;
    if (self.delegate) {
        [self.delegate hidingAction];
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
