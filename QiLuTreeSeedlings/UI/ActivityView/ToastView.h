//
//  ToastView.h
//  baba88
//
//  Created by JCAI on 15/7/25.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kToastTopYOffset         66.0f
#define kToastViewYOffset        260
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


