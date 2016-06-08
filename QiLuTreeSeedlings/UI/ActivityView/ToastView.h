//
//  ToastView.h
//  baba88
//
//  Created by JCAI on 15/7/25.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

///** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//
///** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
///** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
//#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kToastTopYOffset         66.0f
#define kToastViewYOffset        iPhone4 ? 390 : 480
#define kSizeScreenWidth         [[UIScreen mainScreen] bounds].size.width



@interface ToastView : UIView
{
    // background image view.
    UIImageView *_backgroundView;
    
    // text
    UILabel *_textLabel;
    
    // time to show.
    double _duration;
}

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic,readonly) UILabel *textLabel;
@property (nonatomic) double duration;

-(id)initWithText:(NSString *)text withOriginY:(CGFloat)originY;

-(void)showText;

// show a toast for normal view.
+(void)showToast:(NSString *)text
     withOriginY:(CGFloat)originY
   withSuperView:(UIView *)superview;

+(void)showTopToast:(NSString *)text;
@end


@interface UIColor (Hex)

+ (UIColor *) colorWithHex:(uint) hex;

@end


