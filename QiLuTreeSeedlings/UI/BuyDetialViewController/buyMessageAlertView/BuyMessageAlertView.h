//
//  BuyMessageAlertView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDefines.h"
typedef void(^ActionClickIndexBlock)(NSInteger index);
@interface BuyMessageAlertView : UIView
@property (nonatomic,weak)UIButton *leftBtn;
@property (nonatomic,weak)UIButton *rightBtn;
+(BuyMessageAlertView *)addActionVieWithPrice:(NSString *)price AndMone:(NSString *)yue;
+(void)removeActionView;
@end
