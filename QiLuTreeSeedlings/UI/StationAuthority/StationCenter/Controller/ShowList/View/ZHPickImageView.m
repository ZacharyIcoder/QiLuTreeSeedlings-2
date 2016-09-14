//
//  PickImageView.m
//  ZhenHao
//
//  Created by Apple on 15/10/9.
//  Copyright (c) 2015年 ShanDongSanMi. All rights reserved.
//

#import "ZHPickImageView.h"
#import "UIView+MJExtension.h"

#import "ZHPickerBtn.h"
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

//获取屏幕宽跟高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.height - 20))
#define NavBarHeight ((IS_IOS_7)?65:45)

@interface ZHPickImageView ()<ZHPickerBtnDeleteDelegate>

@property(nonatomic, strong) NSMutableArray *imageBtnArr;
@property(nonatomic, strong) UIButton       *pickBtn;


@end

@implementation ZHPickImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.photos = [[NSMutableArray alloc]  initWithCapacity:0];
        
        self.pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pickBtn setImage:[UIImage imageNamed:@"shangchuanzhaopian"] forState:UIControlStateNormal];
        [self.pickBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pickBtn];
        [self.imageBtnArr addObject:self.pickBtn];
    }
    
    return self;
}

- (void)initUI {
    self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.photos = [[NSMutableArray alloc]  initWithCapacity:0];

    self.pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pickBtn setImage:[UIImage imageNamed:@"shangchuanzhaopian"] forState:UIControlStateNormal];
    [self.pickBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pickBtn];
    [self.imageBtnArr addObject:self.pickBtn];

}

- (void)addImage:(UIImage *)image
{
    
    [self.photos addObject:image];
    
    
    ZHPickerBtn *imageBtn = [ZHPickerBtn buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    imageBtn.deleteDelegate = self;

    [self addSubview:imageBtn];
    
    [self.imageBtnArr insertObject:imageBtn atIndex:0];
    
    //最多允许添加9张图片
    
    if (self.imageBtnArr.count == 10) {
        
        self.pickBtn.hidden = YES;
    }
    
    [self setNeedsLayout];
}


- (void)removeImage:(UIImage *)image
{
    
}

- (void)layoutSubviews
{
    
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    NSInteger row_nums = 3;
    CGFloat marginX = 10;
    CGFloat imageViewW = (ScreenWidth - (row_nums+1)*marginX)/row_nums;
    CGFloat imageViewH = imageViewW;
    
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    
    for(NSInteger i = 0; i< self.imageBtnArr.count; i++)
    {
        imageViewX  = marginX + i%row_nums*(marginX + imageViewW);
        imageViewY = marginX + i/row_nums*(marginX + imageViewH);
        
        ZHPickerBtn *imageView = self.imageBtnArr[i];
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
    }
    
    UIButton *lastImageBtn= [self.imageBtnArr lastObject];
    self.mj_height = CGRectGetMaxY(lastImageBtn.frame) + marginX;
    
    
    if (CGRectGetMaxY(self.frame) + marginX > ScreenHeight) {
        
        scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.frame) + marginX + NavBarHeight);
    }
}



- (void)pickImageBtnClicked:(UIButton * )pickBtn
{
//    ZHLog(@"pickImageBtnClicked!");

    
    if (self.takePhotoBlock) {
        self.takePhotoBlock();
    }
}

#pragma mark ---------------delete Picture delegate----------

- (void)pickBtnDelete:(ZHPickerBtn *)pickBtn
{
    UIImage *image = [pickBtn currentBackgroundImage];
    [self.photos removeObject:image];
    
    
    [pickBtn removeFromSuperview];
    [self.imageBtnArr removeObject:pickBtn];
    [self setNeedsLayout];
    if (self.photos.count < 9) {
        self.pickBtn.hidden = NO;
    }
}



@end
