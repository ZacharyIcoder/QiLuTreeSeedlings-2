//
//  ZIKSupplyBottomSelectButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyBottomSelectButton.h"
#import "UIView+KMJExtension.h"
@implementation ZIKSupplyBottomSelectButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        //self.backgroundColor = [UIColor yellowColor];

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = 23;
    CGFloat w = h;
    CGFloat x = 5;
    CGFloat y = 2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.mj_width/3, 0, self.mj_width*2/3, self.mj_height);
}

@end
