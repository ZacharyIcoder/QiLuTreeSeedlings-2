//
//  ZIKHeZuoMiaoQiListSelectAddressView.m
//  QiLuTreeSeedlings
//
//  Created by 孔德志 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHeZuoMiaoQiListSelectAddressView.h"
@interface ZIKHeZuoMiaoQiListSelectAddressView ()
{
    CGRect myframe;
}
@end
@implementation ZIKHeZuoMiaoQiListSelectAddressView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKHeZuoMiaoQiListSelectAddressView" owner:nil options:nil];
        self = [nibView objectAtIndex:0];
//        self.frame = frame;
        myframe = frame;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    self.frame = myframe;
}


@end
