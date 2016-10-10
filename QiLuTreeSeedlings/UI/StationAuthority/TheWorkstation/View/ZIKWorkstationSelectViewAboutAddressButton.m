//
//  ZIKWorkstationSelectViewAboutAddressButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectViewAboutAddressButton.h"
#import "UIView+KMJExtension.h"
#import "UIDefines.h"
@implementation ZIKWorkstationSelectViewAboutAddressButton

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
////        [self setTitleColor:DarkTitleColor forState:UIControlStateNormal];
//        self.backgroundColor = [UIColor whiteColor];
//        self.titleLabel.backgroundColor = [UIColor whiteColor];
//        self.imageView.backgroundColor  = [UIColor whiteColor];
//        self.lzType = LZRelayoutButtonTypeLeft;
////        self.titleLabel.font = [UIFont systemFontOfSize:14];
////        self.titleLabel.textAlignment = NSTextAlignmentLeft;
//////        self.titleLabel.backgroundColor = button.backgroundColor;
////        self.imageView.backgroundColor = self.backgroundColor;
////        //在使用一次titleLabel和imageView后才能正确获取titleSize
////        CGSize titleSize = self.titleLabel.bounds.size;
////        CGSize imageSize = self.imageView.bounds.size;
////        CGFloat interval = 1.0;
////
////        self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
////        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
//    }
//    return self;
//}

- (void)setLzType:(LZRelayoutButtonType)lzType {
    _lzType = lzType;

    if (lzType != LZRelayoutButtonTypeNomal) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

//重写父类方法,改变标题和image的坐标
- (CGRect)imageRectForContentRect:(CGRect)contentRect {

    if (self.lzType == LZRelayoutButtonTypeLeft) {
        CGFloat inteval = CGRectGetHeight(contentRect)/8.0;

        //设置图片的宽高为button高度的3/4;
        CGFloat imageH = CGRectGetHeight(contentRect) - 2 * inteval;
//        CGFloat imageH = CGRectGetHeight(contentRect) - 2 * inteval;


//        CGRect rect = CGRectMake(CGRectGetWidth(contentRect) - imageH - inteval, inteval, imageH, imageH);
        CGRect rect = CGRectMake(CGRectGetWidth(contentRect) - imageH - inteval, inteval+3, 15, 10);


        return rect;
    } else if (self.lzType == LZRelayoutButtonTypeBottom) {
        CGFloat inteval = CGRectGetWidth(contentRect)/16.0;
        inteval = MIN(inteval, 6);

        //设置图片的宽高为button宽度的7/8;
        CGFloat imageW = CGRectGetWidth(contentRect) - 2 * inteval;

        CGRect rect = CGRectMake(inteval, inteval, imageW, imageW);

        return rect;
    } else {
        return [super imageRectForContentRect:contentRect];
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {

    if (self.lzType == LZRelayoutButtonTypeLeft) {
        CGFloat inteval = CGRectGetHeight(contentRect)/8.0;
        //设置图片的宽高为button高度的3/4;
        CGFloat imageH = CGRectGetHeight(contentRect) - 2 * inteval;

        CGRect rect = CGRectMake(inteval, inteval, CGRectGetWidth(contentRect) - imageH - 2*inteval, CGRectGetHeight(contentRect) - 2*inteval);

        return rect;
    } else if (self.lzType == LZRelayoutButtonTypeBottom) {
        CGFloat inteval = CGRectGetWidth(contentRect)/16.0;
        inteval = MIN(inteval, 6);

        //设置图片的宽高为button宽度的7/8;
        CGFloat imageW = CGRectGetWidth(contentRect) - 2 * inteval;

        CGRect rect = CGRectMake(0, inteval*2 + imageW, CGRectGetWidth(contentRect) , CGRectGetHeight(contentRect) - 3*inteval - imageW);

        return rect;
    } else {
        return [super titleRectForContentRect:contentRect];
    }
}

//-(void)layoutSubviews {
//    
//}
@end
