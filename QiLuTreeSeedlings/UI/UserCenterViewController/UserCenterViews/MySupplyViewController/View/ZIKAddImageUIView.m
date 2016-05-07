//
//  ZIKAddImageUIView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKAddImageUIView.h"
#import "UIDefines.h"
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
{
    UIView *_hintView;
    UILabel *_hintLabel;
}
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

        _hintView = [[UIView alloc] init];
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"注 : 为了避免照片上传后变形,请尽量横拍";
        _hintLabel.font = [UIFont systemFontOfSize:13.0f];
        _hintLabel.textColor = yellowButtonColor;
        [_hintView addSubview:_hintLabel];
        [self addSubview:_hintView];

        _hintView.frame = CGRectMake(0, frame.size.height-30, frame.size.width, 30);
        _hintLabel.frame = CGRectMake(60, 0, _hintView.frame.size.width-80, 30);

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
    NSInteger row_nums = 3;
    CGFloat btnY = 15;
    CGFloat intervalX = 15;
    CGFloat btnW = (Width - (row_nums + 1) * intervalX)/row_nums;
    CGFloat btnH = btnW;
    self.oneBtn.frame = CGRectMake(intervalX, btnY, btnW, btnH);
    self.twoBtn.frame = CGRectMake(CGRectGetMaxX(self.oneBtn.frame)+intervalX, self.oneBtn.frame.origin.y, self.oneBtn.frame.size.width, self.oneBtn.frame.size.height);
    self.threeBtn.frame = CGRectMake(CGRectGetMaxX(self.twoBtn.frame)+intervalX, self.oneBtn.frame.origin.y, self.oneBtn.frame.size.width, self.oneBtn.frame.size.height);

}

@end
