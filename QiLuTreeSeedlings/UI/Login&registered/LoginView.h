//
//  LoginView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate <NSObject>

- (void)LoginbtnAction:(NSString *)phone andPassword:(NSString *)pasword;

@end
@interface LoginView : UIView
@property (nonatomic,weak) id<LoginViewDelegate> delegate;
@end
