//
//  NomarBaseViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface NomarBaseViewController : UIViewController
@property (nonatomic,weak)UIButton *backBtn;
@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic,strong) UIView *navBackView;
-(void)backBtnAction:(UIButton *)sender;
@end
