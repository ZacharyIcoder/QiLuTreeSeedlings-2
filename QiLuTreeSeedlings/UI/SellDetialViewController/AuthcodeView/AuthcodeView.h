//
//  AuthcodeView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView
@property (strong, nonatomic) NSArray *dataArray;//字符素材数组
@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串
@end
