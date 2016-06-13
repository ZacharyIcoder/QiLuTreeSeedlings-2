//
//  YLDSearchView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDSearchView.h"
#import "UIDefines.h"
@interface YLDSearchView ()
@property (nonatomic,strong) UIButton *shengBtn;
@property (nonatomic,strong) UIButton *shiBtn;
@property (nonatomic,strong) UIButton *xianBtn;
@end
@implementation YLDSearchView
-(id)initWithColor:(UIColor *)zitiYanse{
    self=[super init];
    if (self) {
        [self setFrame:CGRectMake(0, 64, kWidth, 50)];
    }
    return self;
}
@end
