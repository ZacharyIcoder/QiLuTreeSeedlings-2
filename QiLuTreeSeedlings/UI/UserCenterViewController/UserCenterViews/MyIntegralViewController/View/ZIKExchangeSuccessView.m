//
//  ZIKExchangeSuccessView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKExchangeSuccessView.h"

@implementation ZIKExchangeSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(ZIKExchangeSuccessView *)successView {
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"ZIKExchangeSuccessView" owner:nil options:nil];
    ZIKExchangeSuccessView *view = [objs firstObject];
//    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
//    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
//    view.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
//    view.layer.shadowRadius  = 3;//阴影半径，默认3
    return view;
}


@end
