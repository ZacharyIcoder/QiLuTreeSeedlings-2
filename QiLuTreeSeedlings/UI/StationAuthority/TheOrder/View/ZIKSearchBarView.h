//
//  ZIKSearchBarView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SearchBlock) ( NSString *);
typedef void (^LeftBtnClickedBlock) ();

@interface ZIKSearchBarView : UIView
/**
 *  占位符
 */
@property(nonatomic, strong) NSString    * placeHolder;

/**
 *  右边的search的图像
 *
 */
@property(nonatomic, strong) UIImage    * searchIcon;
@property(nonatomic, weak) UITextField  * textField;
/**
 *  背景图片，后期有空，用代码生成，只传颜色就好了
 */
@property(nonatomic, strong) UIImage    *  zhBackgroundImage;

@property(nonatomic, weak) id<UITextFieldDelegate> delegate;

@property(nonatomic, copy) SearchBlock searchBlock;
@property(nonatomic, copy) LeftBtnClickedBlock leftBtnBlock;


@property(nonatomic, strong) UIImage    * leftIcon;

//处理点击事件

// the action cannot be NULL. Note that the target is not retained.
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
