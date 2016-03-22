//
//  UIViewController+Ext.m
//  baba88
//
//  Created by JCAI on 15/7/17.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "UIViewController+Ext.h"
#import "UIDefines.h"


@implementation UIViewController (UINavigationController)

#pragma mark - 设置透明上导航
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)setNavColor
{
    UIImage *image = [self imageWithColor:NavColor];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:NavColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}


- (void)setNavTitle:(NSString *)title
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [tempLabel setBackgroundColor:[UIColor clearColor]];
    [tempLabel setTextAlignment:NSTextAlignmentCenter];
    [tempLabel setTextColor:[UIColor whiteColor]];
    [tempLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [tempLabel setText:title];
    self.navigationItem.titleView = tempLabel;
}

- (void)setNavLeftBarButton:(CGRect)frame
                      title:(NSString *)title
                     action:(SEL)action
                normalImage:(UIImage *)normalImage
             highlightImage:(UIImage *)highlightImage
{
    CGRect tempFrame = frame;
    UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
    [tempButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [tempButton setTitle:title forState:UIControlStateNormal];
    [tempButton addTarget:self
                   action:action
         forControlEvents:UIControlEventTouchUpInside];
    if (normalImage) {
        [tempButton setBackgroundImage:normalImage
                              forState:UIControlStateNormal];
    }
    if (highlightImage) {
        [tempButton setBackgroundImage:highlightImage
                              forState:UIControlStateHighlighted];
    }
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)setNavRightBarButton:(CGRect)frame
                       title:(NSString *)title
                      action:(SEL)action
                 normalImage:(UIImage *)normalImage
              highlightImage:(UIImage *)highlightImage
{
    CGRect tempFrame = frame;
    UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
    [tempButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [tempButton setTitle:title forState:UIControlStateNormal];
    [tempButton addTarget:self
                   action:action
         forControlEvents:UIControlEventTouchUpInside];
    if (normalImage) {
        [tempButton setBackgroundImage:normalImage
                              forState:UIControlStateNormal];
    }
    if (highlightImage) {
        [tempButton setBackgroundImage:highlightImage
                              forState:UIControlStateHighlighted];
    }
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


#pragma mark - 
- (void)setNavBack:(SEL)action
{
    [self setNavLeftBarButton:CGRectMake(0, 0, 20, 20)
                        title:@""
                       action:action
                  normalImage:[UIImage imageNamed:@"navBack.png"]
               highlightImage:[UIImage imageNamed:@"navBack.png"]];
}

#pragma mark -
- (void)setNavNull
{
    [self setNavLeftBarButton:CGRectMake(0, 0, 20, 20)
                        title:@""
                       action:nil
                  normalImage:nil
               highlightImage:nil];
}

@end
