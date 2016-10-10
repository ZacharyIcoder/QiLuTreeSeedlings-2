//
//  ZIKShareButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShareButton.h"

#import "UIView+KMJExtension.h"
#import "UIDefines.h"

@implementation ZIKShareButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = 22;
    CGFloat w = h;
    CGFloat x = 31;
    CGFloat y = 0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, 35, self.mj_height);
}


@end
