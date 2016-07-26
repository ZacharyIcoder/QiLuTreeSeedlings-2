//
//  ToastView.m
//  baba88
//
//  Created by JCAI on 15/7/25.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "ToastView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation ToastView

const unsigned int kToastFontSize = 14;
const unsigned int kToastLabelWidth = 150;
const unsigned int kToastLabelHeight = 25;

@synthesize backgroundView = _backgroundView;
@synthesize textLabel = _textLabel;
@synthesize duration = _duration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}
- (void)showText
{
    [UIView beginAnimations:@"show" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3f];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    
}

- (void)hide
{
    [self performSelectorOnMainThread:@selector(hideThread) withObject:nil waitUntilDone:NO];
}

- (void)hideThread {
	[UIView beginAnimations:@"hide" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1f];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	//self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"hide"])
    {
        [self removeFromSuperview];
        //        self = nil;
    }
    else if ([animationID isEqualToString:@"show"])
    {
        if (_duration == 0.0)
            _duration = 1.7;
        [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }
}
/*
 const unsigned int kToastNetWidth = 212;
 const unsigned int kToastNetHeight = 150;
 const unsigned int kToastNetLabelY = 104;
 const unsigned int kNetworkWidth = 80;
 const unsigned int kNetworkHeight = 60;
 const unsigned int kNetworkY = 26;
 - (NCToastView *)initForNetAbnormal
 {
 CGRect rect;
 rect.size.width = kToastNetWidth;
 rect.size.height = kToastNetHeight;
 rect.origin.x = ((kSizeScreenWidth - kToastNetWidth) / 2);
 rect.origin.y = ((kSizeScreenHeight - kToastNetHeight) / 2);
 
 
 NCToastView *toast = [[NCToastView alloc] initWithFrame:rect];
 
 UIImage *background = [UIImage imageNamed:NSLocalizedString(@"ToastBackgroundImage", nil)];
 UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:background];
 [toast addSubview:backgroundImageView];
 [backgroundImageView release];
 
 UIImage *network = [UIImage imageNamed:NSLocalizedString(@"NetworkErrorImage", nil)];
 UIImageView *networkImageView = [[UIImageView alloc] initWithImage:network];
 networkImageView.frame = CGRectMake((kToastNetWidth - kNetworkWidth)/2, kNetworkY, kNetworkWidth, kNetworkHeight);
 [toast addSubview:networkImageView];
 [networkImageView release];
 
 UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kToastNetLabelY, kToastNetWidth, kToastFontSize)];
 textLabel.backgroundColor = [UIColor clearColor];
 textLabel.textAlignment = UITextAlignmentCenter;
 textLabel.font = [UIFont systemFontOfSize:kToastFontSize];
 textLabel.textColor = [UIColor whiteColor];
 textLabel.numberOfLines = 1;
 textLabel.lineBreakMode = UILineBreakModeWordWrap;
 textLabel.text = NSLocalizedString(@"NetWorkError", nil);
 [toast addSubview:textLabel];
 [textLabel release];
 
 toast.alpha = 0.0f;
 
 return toast;
 }
 */

/*
 - (NCToastView*)init:(NSString *)text FrameOriginY:(CGFloat)originY
 {
 UILabel *textLabel = [[UILabel alloc] init];
 textLabel.backgroundColor = [UIColor clearColor];
 textLabel.textAlignment = UITextAlignmentCenter;
 textLabel.font = [UIFont systemFontOfSize:kToastFontSize];
 textLabel.textColor = [UIColor whiteColor];
 textLabel.numberOfLines = 0;
 textLabel.lineBreakMode = UILineBreakModeWordWrap;
 CGSize sz = [text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(kToastLabelWidth - 20.0f, 9999.0f) lineBreakMode:textLabel.lineBreakMode];
 
 CGRect rect;
 rect.size.width = kToastLabelWidth;
 rect.size.height = kToastLabelHeight;
 rect.origin.x = ((kSizeScreenWidth - kToastLabelWidth) / 2.0);
 rect.origin.y = originY;
 
 
 NCToastView *toast = [[NCToastView alloc] initWithFrame:rect];
 toast.backgroundColor = [UIColor colorWithHex:0xFF000000];
 CALayer *layer = toast.layer;
 layer.masksToBounds = YES;
 layer.cornerRadius = 5.0f;
 
 textLabel.text = text;
 rect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
 rect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
 rect.size = sz;
 textLabel.frame = rect;
 [toast addSubview:textLabel];
 [textLabel release];
 
 toast.alpha = 0.0f;
 
 return toast;
 }
 */

-(id)initWithText:(NSString *)text withOriginY:(CGFloat)originY
{
    self = [super init];
    if (self)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:kToastFontSize];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:_textLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
        CGSize sizeString = [text boundingRectWithSize:CGSizeMake(kSizeScreenWidth, 25)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil].size;
        CGFloat _toastLableWidth = kToastLabelWidth;
        CGSize sz;
        if (sizeString.width > (kToastLabelWidth -20.0f))
        {
            _toastLableWidth = sizeString.width + 10.0f;
            NSDictionary *attributes = @{NSFontAttributeName:_textLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
            sz = [text boundingRectWithSize:CGSizeMake(_toastLableWidth - 10.0f, 200.0f)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size;
        }
        else
        {
            NSDictionary *attributes = @{NSFontAttributeName:_textLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
            sz = [text boundingRectWithSize:CGSizeMake(_toastLableWidth - 20.0f, 200.0f)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size;
        }
        [paragraphStyle release];
        // To reduce sizeWithFont method's deviation, add one word width to sz.
        if (sz.width + kToastFontSize < _toastLableWidth)
            sz.width = sz.width + kToastFontSize;
        
        CGRect rect;
        rect.size.width = _toastLableWidth;
        rect.size.height = kToastLabelHeight;
        rect.origin.x = ((kSizeScreenWidth - _toastLableWidth) / 2.0);
        rect.origin.y = originY;
        
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel.text = text;
        rect.origin.x = floor((self.frame.size.width - sz.width) / 2.0f);
        rect.origin.y = floor((self.frame.size.height - sz.height) / 2.0f);
        rect.size = sz;
        _textLabel.frame = rect;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.8f;
        backgroundView.layer.cornerRadius = 8;
        [self addSubview:backgroundView];
        [backgroundView release];
        
        [self addSubview:_textLabel];
        self.alpha = 0.0f;
    }
    return self;
}

// show normal toast.frequently used.
+(void)showToast:(NSString *)text
     withOriginY:(CGFloat)originY
   withSuperView:(UIView *)superview
{
    ToastView *toastView = [[ToastView alloc] initWithText:text withOriginY:kToastViewYOffset];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:toastView];
    [toastView showText];
    [toastView release];
}
+(void)showTopToast:(NSString *)text
{
    ToastView *toastView = nil;
    if ([text isEqualToString:@"您已退出登录"]) {
        toastView = [[ToastView alloc] initWithText:text withOriginY:kToastViewYOffset-50];

    } else {
        toastView = [[ToastView alloc] initWithText:text withOriginY:kToastViewYOffset];
    }
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:toastView];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:toastView];
    [toastView showText];
    [toastView release];
}
@end

@implementation UIColor (Hex)

+ (UIColor *) colorWithHex:(uint) hex
{
	int red, green, blue, alpha;
	
	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);
	
	return [UIColor colorWithRed:red/255.0f
						   green:green/255.0f
							blue:blue/255.0f
						   alpha:alpha/255.f];
}

@end
