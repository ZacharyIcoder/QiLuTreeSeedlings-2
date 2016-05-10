//
//  ZIKPickerBtn.m
//  SanMiKeJi
//
//  Created by Apple on 15/10/22.
//  Copyright © 2015年 ShanDongSanMi. All rights reserved.
//

#import "ZIKPickerBtn.h"
#import "UIView+MJExtension.h"

@interface ZIKPickerBtn ()

@property(nonatomic, weak) UIButton *deleteBtn;


@end

@implementation ZIKPickerBtn

- (instancetype)init
{
    if (self = [super init]) {
        
        self.urlDic = [[NSDictionary alloc] init];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.highlighted = NO;
    
    
    NSInteger deleteBtnW = self.mj_width/3;
    NSInteger deleteBtnH = deleteBtnW;
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(self.mj_width-deleteBtnW, 0, deleteBtnW, deleteBtnH);
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:deleteBtn];
}


- (void)deleteBtnClicked:(UIButton *)button
{
    if (self.deleteDelegate && [self.deleteDelegate respondsToSelector:@selector(pickBtnDelete:)]) {
        [self.deleteDelegate pickBtnDelete:self];
    }
}
@end
