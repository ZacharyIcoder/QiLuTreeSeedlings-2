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
    return view;
}


@end
