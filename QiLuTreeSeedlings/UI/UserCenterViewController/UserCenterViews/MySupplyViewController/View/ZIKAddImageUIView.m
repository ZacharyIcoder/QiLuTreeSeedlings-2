//
//  ZIKAddImageUIView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKAddImageUIView.h"
#import "UIDefines.h"
#import "ZIKPickerBtn.h"
// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

@interface ZIKAddImageUIView ()<ZIKPickerBtnDeleteDelegate>

@property(nonatomic, strong) NSMutableArray *imageBtnArr;
@property(nonatomic, strong) ZIKPickerBtn       *oneBtn;//单柱
@property(nonatomic, strong) ZIKPickerBtn       *twoBtn;//整片
@property(nonatomic, strong) ZIKPickerBtn       *threeBtn;//合影

@end

@implementation ZIKAddImageUIView
{
    UIView *_hintView;
    UILabel *_hintLabel;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.imageBtnArr = [[NSMutableArray alloc] initWithCapacity:2];
//        self.photos = [[NSMutableArray alloc]  initWithCapacity:2];
//        self.urlMArr = [[NSMutableArray alloc] initWithCapacity:2];
//        _btnNum = 0;
//
//        self.oneBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
//        [self.oneBtn setImage:[UIImage imageNamed:@"添加照片-单株"] forState:UIControlStateNormal];
//        [self.oneBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.oneBtn];
//        self.oneBtn.isHiddenDeleteBtn = YES;
////        self.oneBtn.tag = 101;
//        [self.imageBtnArr addObject:self.oneBtn];
//
//        self.twoBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
//        [self.twoBtn setImage:[UIImage imageNamed:@"添加照片-整片"] forState:UIControlStateNormal];
//        [self.twoBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.twoBtn];
//        [self.imageBtnArr addObject:self.twoBtn];
////        self.twoBtn.tag = 102;
//        self.twoBtn.isHiddenDeleteBtn = YES;
//
//        self.threeBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
//        [self.threeBtn setImage:[UIImage imageNamed:@"添加照片-人苗"] forState:UIControlStateNormal];
//        [self.threeBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.threeBtn];
//        [self.imageBtnArr addObject:self.threeBtn];
////        self.threeBtn.tag = 103;
//        self.threeBtn.isHiddenDeleteBtn = YES;
//
//        _hintView = [[UIView alloc] init];
//        _hintLabel = [[UILabel alloc] init];
//        _hintLabel.text = @"注 : 为了避免照片上传后变形,请尽量横拍";
//        _hintLabel.font = [UIFont systemFontOfSize:13.0f];
//        _hintLabel.textColor = yellowButtonColor;
//        [_hintView addSubview:_hintLabel];
//        [self addSubview:_hintView];
//
//        _hintView.frame = CGRectMake(0, frame.size.height-30, frame.size.width, 30);
//        _hintLabel.frame = CGRectMake(60, 0, _hintView.frame.size.width-80, 30);
//
//    }
//    return self;
//}
//
//- (void)imageBtnClicked:(UIButton * )pickBtn
//{
//    if (self.takePhotoBlock) {
//        self.takePhotoBlock();
//    }
//}
//
//- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic
//{
//    ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
//    [imageBtn setImage:image forState:UIControlStateNormal];
//    imageBtn.deleteDelegate = self;
//    imageBtn.isHiddenDeleteBtn = NO;
//    [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:imageBtn];
//
//    [self.imageBtnArr replaceObjectAtIndex:_btnNum++ withObject:imageBtn];
//
//    /***********************************/
//
//    [self.photos addObject:image];
//    [self.urlMArr addObject:urlDic];
//
//    [self setNeedsLayout];
//}
//
//- (void)addImageUrl:(UIImage *)image withUrl:(NSDictionary *)urlDic
//{
//    if (self.photos.count == 0) {
//        [self.oneBtn setImage:image forState:UIControlStateNormal];
//        self.oneBtn.isHiddenDeleteBtn = NO;
//        self.oneBtn.urlDic = urlDic;
//        self.oneBtn.deleteDelegate = self;
//    }
//    else if (self.photos.count == 1) {
//        [self.twoBtn setImage:image forState:UIControlStateNormal];
//        self.twoBtn.isHiddenDeleteBtn = NO;
//        self.twoBtn.urlDic = urlDic;
//        self.twoBtn.deleteDelegate = self;
//
//    }
//    else if (self.photos.count == 2) {
//        [self.threeBtn setImage:image forState:UIControlStateNormal];
//        self.threeBtn.isHiddenDeleteBtn = NO;
//        self.threeBtn.urlDic = urlDic;
//        self.threeBtn.deleteDelegate = self;
//
//    }
//    /***********************************/
//
//    [self.photos addObject:image];
//    [self.urlMArr addObject:urlDic];
//
//    [self setNeedsLayout];
//}
//
//-(void)setUrlMArr:(NSMutableArray *)urlMArr {
//    _urlMArr = urlMArr;
//    for (NSDictionary *dic in urlMArr) {
//        [self addImageUrl:[UIImage
//                           imageWithData:[NSData
//                                          dataWithContentsOfURL:[NSURL
//                                                                 URLWithString:dic[@"compressurl"]]]] withUrl:dic];
//    }
//}
//
//- (void)layoutSubviews
//{
//    NSInteger row_nums = 3;
//    CGFloat  marginX   = 15;
//    CGFloat imageViewW = (Width - (row_nums+1)*marginX)/row_nums;
//    CGFloat imageViewH = imageViewW;
//
//    CGFloat imageViewX = marginX;
//    CGFloat imageViewY = 15;
//
//    for(NSInteger i = 0; i < self.imageBtnArr.count; i++)
//    {
//        imageViewX  = marginX + i%row_nums*(marginX + imageViewW);
//        //imageViewY = marginX + i/row_nums*(marginX + imageViewH);
//
//        ZIKPickerBtn *imageView = self.imageBtnArr[i];
//        CLog(@"%d",imageView.isHiddenDeleteBtn);
//        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    }
//
//}
//
//
//#pragma mark ---------------delete Picture delegate----------
//
//- (void)pickBtnDelete:(ZIKPickerBtn *)pickBtn
//{
//    UIImage *image = [pickBtn currentImage];
//    pickBtn.isHiddenDeleteBtn = YES;
//    [self.photos removeObject:image];
//    [self.urlMArr removeObject:pickBtn.urlDic];
//    //[self.imageBtnArr removeObject:pickBtn];
//    [self setNeedsLayout]; 
//}

@end
