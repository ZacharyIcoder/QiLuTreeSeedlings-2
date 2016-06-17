//
//  ZIKSelectMenuView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKSelectMenuView.h"
#import "UIDefines.h"
/*****宏定义******/
#define NAV_HEIGHT 64 //navgationview 高度
#define MENUVIEW_HEIGHT 43  //button 选择菜单高度

@interface ZIKSelectMenuView ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ZIKSelectMenuView
{
    UIButton *_cuttentButton;
}
-(instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array  {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor     = [UIColor whiteColor];
        self.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
        self.layer.shadowOpacity = 0.2;////阴影透明度，默认0
        self.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowRadius  = 3;//阴影半径，默认3
        self.contentMode = UIViewContentModeScaleToFill;

        CGFloat padding = 0.0f;
        CGFloat split = kWidth / array.count;
        for (NSInteger i = 0; i < array.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 5, split, 30)];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
            padding += split;
            if (i == 0) {
                _cuttentButton = btn;
                [btn setTitleColor:NavColor forState:UIControlStateNormal];
            }
        }
        //线
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, frame.size.height-3, split, 3);
        _lineView.backgroundColor = NavColor;
        [self addSubview:_lineView];

    }
    return self;
}

- (void)actionMenu:(UIButton *)button {
    if (self.menuBtnBlock) {
        self.menuBtnBlock(button.tag);
    }
    if (_cuttentButton != button) {
        [button setTitleColor:NavColor forState:UIControlStateNormal];
        [_cuttentButton setTitleColor:titleLabColor forState:UIControlStateNormal];
        _cuttentButton = button;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(button.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
        }];
    }
}

-(void)setMenuBtnBlock:(MenuBtnBlock)menuBtnBlock {
    _menuBtnBlock = [menuBtnBlock copy];
}

@end
