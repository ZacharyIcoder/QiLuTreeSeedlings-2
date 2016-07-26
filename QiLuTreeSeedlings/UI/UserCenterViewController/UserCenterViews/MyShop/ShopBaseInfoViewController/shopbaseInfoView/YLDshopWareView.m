//
//  YLDshopWareView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDshopWareView.h"
#import "UIDefines.h"
@implementation YLDshopWareView
-(void)addTextWithAry:(NSArray *)ary
{
    for (int i=0; i<ary.count; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(65, 10+i*31, 220, 21)];
        [lab setTextColor:yellowButtonColor];
        [lab setFont:[UIFont systemFontOfSize:15]];
        [lab setText:ary[i]];
        [lab sizeToFit];
        [self addSubview:lab];
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
