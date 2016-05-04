//
//  ZIKMySupplyCellBackButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyCellBackButton.h"
#import "UIView+MJExtension.h"
#import "UIDefines.h"
@implementation ZIKMySupplyCellBackButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:kRedHintColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = 20;
    CGFloat w = h;
    CGFloat x = self.mj_width/2-40-20;
    CGFloat y = 7;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.mj_width/2-37, 0, self.mj_width/2, self.mj_height);
}


@end
