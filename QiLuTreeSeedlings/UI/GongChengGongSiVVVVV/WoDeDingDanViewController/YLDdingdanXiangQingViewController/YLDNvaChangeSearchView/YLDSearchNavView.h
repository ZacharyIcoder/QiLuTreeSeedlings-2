//
//  YLDSearchNavView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDSearchNavViewDelegate <NSObject>
@optional
-(void)textFieldChangeVVWithStr:(NSString *)textStr;
-(void)hidingAction;
@end
@interface YLDSearchNavView : UIView<UITextFieldDelegate>
@property (nonatomic,weak) id<YLDSearchNavViewDelegate> delegate;
@property (nonatomic,weak) UITextField *textfield;
@property (nonatomic,weak) UIButton *hidingBtn;
@end
