//
//  PickImageView.m
//
//  Created by Apple on 15/10/9.
//  Copyright (c) 2015年 ShanDongSanMi. All rights reserved.
//
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

//获取屏幕宽跟高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define NavBarHeight ((IS_IOS_7)?65:45)

#define BottomHeight ((IS_IOS_7)?49:0)

#define ScreenHeight ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.height - 20))

#import "ZIKPickImageView.h"
#import "UIView+KMJExtension.h"

#import "ZIKPickerBtn.h"
#import "UIImageView+AFNetworking.h"

@interface ZIKPickImageView ()<ZIKPickerBtnDeleteDelegate>

@property(nonatomic, strong) NSMutableArray *imageBtnArr;
@property(nonatomic, strong) UIButton       *pickBtn;


@end

@implementation ZIKPickImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:2];
        self.photos = [[NSMutableArray alloc]  initWithCapacity:2];
        self.urlMArr = [[NSMutableArray alloc] initWithCapacity:2];
        self.pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pickBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [self.pickBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pickBtn];
        [self.imageBtnArr addObject:self.pickBtn];
    }
    
    return self;
}
- (void)initUI {
    self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:2];
    self.photos = [[NSMutableArray alloc]  initWithCapacity:2];
    self.urlMArr = [[NSMutableArray alloc] initWithCapacity:2];
    self.pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pickBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.pickBtn addTarget:self action:@selector(pickImageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pickBtn];
    [self.imageBtnArr addObject:self.pickBtn];

}
- (void)addImageURL:(NSDictionary *)dic
{
    [self.urlMArr addObject:dic];
}

- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic
{


    [self.photos addObject:image];
    [self.urlMArr addObject:urlDic];
    
    ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    imageBtn.urlDic = urlDic;
    imageBtn.deleteDelegate = self;
    
    [self addSubview:imageBtn];
    
    [self.imageBtnArr insertObject:imageBtn atIndex:self.imageBtnArr.count-1];
    
    //最多允许添加9张图片
    
    if (self.imageBtnArr.count == 4) {
        
        self.pickBtn.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void)addImageUrl:(UIImage *)image withUrl:(NSDictionary *)urlDic
{

    [self.photos addObject:image];

    ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    imageBtn.urlDic = urlDic;
    imageBtn.deleteDelegate = self;

    [self addSubview:imageBtn];

    [self.imageBtnArr insertObject:imageBtn atIndex:self.imageBtnArr.count-1];

    //最多允许添加9张图片

    if (self.imageBtnArr.count == 4) {

        self.pickBtn.hidden = YES;
    }

    [self setNeedsLayout];
}

-(void)setUrlMArr:(NSMutableArray *)urlMArr {
    _urlMArr = urlMArr;
    for (NSDictionary *dic in urlMArr) {
        [self addImageUrl:[UIImage
                        imageWithData:[NSData
                                       dataWithContentsOfURL:[NSURL
                                                              URLWithString:dic[@"compressurl"]]]] withUrl:dic];
    }
}

- (void)removeImage:(UIImage *)image
{
    
}

-(void)removeImageURl:(NSDictionary *)dic {
    
}

- (void)removeALL
{
    if (self.photos.count>0) {
        [self.photos removeAllObjects];
    }
    if (self.urlMArr.count > 0) {
        [self.urlMArr removeAllObjects];
    }
    if (self.imageBtnArr.count > 0) {
        [self.imageBtnArr removeAllObjects];
    }
    if (self.pickBtn) {
        [self.pickBtn removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    
    //UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    NSInteger row_nums = 3;
    CGFloat marginX = 10;
    CGFloat imageViewW = (ScreenWidth-100 - (row_nums+1)*marginX)/row_nums;
    CGFloat imageViewH = imageViewW;
    
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    
    for(NSInteger i = 0; i < self.imageBtnArr.count; i++)
    {
        imageViewX  = marginX + i%row_nums*(marginX + imageViewW);
//        imageViewY = marginX + i/row_nums*(marginX + imageViewH);
        imageViewY = 20;
        ZIKPickerBtn *imageView = self.imageBtnArr[i];
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
    }
    
//    UIButton *lastImageBtn = [self.imageBtnArr lastObject];
    self.mj_height = 100;
   // NSLog(@"-----------------------------------------CGRectGetMaxY(lastImageBtn.frame):%f",CGRectGetMaxY(lastImageBtn.frame));
//    
//    
//    if (CGRectGetMaxY(self.frame) + marginX > ScreenHeight) {
//        
//        scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.frame) + marginX + NavBarHeight);
//    }
}



- (void)pickImageBtnClicked:(UIButton * )pickBtn
{
    
    if (self.takePhotoBlock) {
        self.takePhotoBlock();
    }
}

#pragma mark ---------------delete Picture delegate----------

- (void)pickBtnDelete:(ZIKPickerBtn *)pickBtn
{
    UIImage *image = [pickBtn currentBackgroundImage];
    [self.photos removeObject:image];
    //[self.urlMArr removeObject:(nonnull id)]
    [self.urlMArr removeObject:pickBtn.urlDic];
    [pickBtn removeFromSuperview];
    [self.imageBtnArr removeObject:pickBtn];
    [self setNeedsLayout];
    if (self.photos.count < 3) {
        self.pickBtn.hidden = NO;
    }
}

@end
