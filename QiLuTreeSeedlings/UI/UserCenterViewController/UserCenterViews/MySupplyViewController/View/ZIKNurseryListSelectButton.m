//
//  ZIKNurseryListSelectButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKNurseryListSelectButton.h"
#import "UIView+MJExtension.h"

@implementation ZIKNurseryListSelectButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat h = self.mj_height;
    CGFloat w = h;
    CGFloat x = 0;
    CGFloat y = 0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.mj_height+8, 0, self.mj_width - self.mj_height - 8, self.mj_height);
}



@end
