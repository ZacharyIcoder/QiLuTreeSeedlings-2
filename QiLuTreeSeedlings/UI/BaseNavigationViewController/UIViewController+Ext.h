//
//  UIViewController+Ext.h
//  baba88
//
//  Created by JCAI on 15/7/17.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UIViewController (UINavigationController)

- (void)setNavColor;

- (void)setNavTitle:(NSString *)title;

- (void)setNavLeftBarButton:(CGRect)frame
                      title:(NSString *)title
                     action:(SEL)action
                normalImage:(UIImage *)normalImage
             highlightImage:(UIImage *)highlightImage;

- (void)setNavRightBarButton:(CGRect)frame
                       title:(NSString *)title
                      action:(SEL)action
                 normalImage:(UIImage *)normalImage
              highlightImage:(UIImage *)highlightImage;

#pragma mark -
- (void)setNavBack:(SEL)action;
#pragma mark -
- (void)setNavNull;

@end
