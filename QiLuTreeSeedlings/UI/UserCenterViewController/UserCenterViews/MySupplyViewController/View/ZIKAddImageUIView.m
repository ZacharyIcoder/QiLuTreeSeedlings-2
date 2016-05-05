//
//  ZIKAddImageUIView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKAddImageUIView.h"
// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

@interface ZIKAddImageUIView ()

@property(nonatomic, strong) NSMutableArray *imageBtnArr;
@property(nonatomic, strong) UIButton       *oneBtn;//单柱
@property(nonatomic, strong) UIButton       *twoBtn;//整片
@property(nonatomic, strong) UIButton       *threeBtn;//合影

@end

@implementation ZIKAddImageUIView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:2];
        self.photos = [[NSMutableArray alloc]  initWithCapacity:2];
        self.urlMArr = [[NSMutableArray alloc] initWithCapacity:2];
        self.oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.oneBtn setImage:[UIImage imageNamed:@"添加照片-单株"] forState:UIControlStateNormal];
        [self.oneBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.oneBtn];
        [self.imageBtnArr addObject:self.oneBtn];

        self.twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.twoBtn setImage:[UIImage imageNamed:@"添加照片-整片"] forState:UIControlStateNormal];
        [self.twoBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.twoBtn];
        [self.imageBtnArr addObject:self.twoBtn];

        self.threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.threeBtn setImage:[UIImage imageNamed:@"添加照片-人苗"] forState:UIControlStateNormal];
        [self.threeBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.threeBtn];
        [self.imageBtnArr addObject:self.threeBtn];

    }
    return self;
}

- (void)pickImageBtnClicked:(UIButton * )pickBtn
{

    if (self.takePhotoBlock) {
        self.takePhotoBlock();
    }
}

- (void)layoutSubviews
{
   //self.oneBtn.frame = CGRectMake(15, 10, width, <#CGFloat height#>)
}

@end
