//
//  ZIKAddImageView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKAddImageView.h"
#import "UIDefines.h"
#import "ZIKPickerBtn.h"
#import "UIButton+AFNetworking.h"
// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

#define  ONE_IMAGE    [UIImage imageNamed:@"添加照片-单株"]
#define  TWO_IMAGE    [UIImage imageNamed:@"添加照片-整片"]
#define  THREE_IMAGE  [UIImage imageNamed:@"添加照片-人苗"]

@interface ZIKAddImageView ()<ZIKPickerBtnDeleteDelegate>
@property(nonatomic, strong) ZIKPickerBtn       *oneBtn;//单柱
@property(nonatomic, strong) ZIKPickerBtn       *twoBtn;//整片
@property(nonatomic, strong) ZIKPickerBtn       *threeBtn;//合影

@end
@implementation ZIKAddImageView
{
    //UIImageView *_hintImageView;
    UIView *_hintView;
    UILabel *_hintLabel;
    CGRect _selfFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.urlMArr = [[NSMutableArray alloc] initWithCapacity:2];
         self.haveImageMArr = [[NSMutableArray alloc] init];
        self.btnMarr = [[NSMutableArray alloc] init];
        ZIKPickerBtn *oneBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
        [oneBtn setBackgroundImage:ONE_IMAGE forState:UIControlStateNormal];
        oneBtn.image = ONE_IMAGE;
        [oneBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:oneBtn];
        oneBtn.isHiddenDeleteBtn = YES;
        oneBtn.tag = oneBtnTag;
        self.oneBtn = oneBtn;

        ZIKPickerBtn *twoBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
        [twoBtn setBackgroundImage:TWO_IMAGE forState:UIControlStateNormal];
        twoBtn.image = TWO_IMAGE;
        [twoBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:twoBtn];
        twoBtn.tag = twoBtnTag;
        twoBtn.isHiddenDeleteBtn = YES;
        self.twoBtn = twoBtn;

        ZIKPickerBtn *threeBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
        [threeBtn setBackgroundImage:THREE_IMAGE forState:UIControlStateNormal];
        threeBtn.image = THREE_IMAGE;
        [threeBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:threeBtn];
        threeBtn.tag = threeBtnTag;
        threeBtn.isHiddenDeleteBtn = YES;
        self.threeBtn = threeBtn;

        self.emptyMArr = [NSArray arrayWithObjects:oneBtn,twoBtn,threeBtn, nil];


        _hintView  = [[UIView alloc] init];
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"注 : 为了避免照片上传后变形,请尽量横拍";
        _hintLabel.font = [UIFont systemFontOfSize:13.0f];
        _hintLabel.textColor = yellowButtonColor;
        [_hintView addSubview:_hintLabel];
        [self addSubview:_hintView];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(40, 5, 20, 20);
        imageView.image = [UIImage imageNamed:@"注意"];
        [_hintView addSubview:imageView];


        _hintView.frame  = CGRectMake(0, frame.size.height-30, frame.size.width, 30);
        _hintLabel.frame = CGRectMake(60, 0, _hintView.frame.size.width-80, 30);

    }
    return self;
}

- (void)imageBtnClicked:(ZIKPickerBtn * )pickBtn
{
    if (self.haveImageMArr.count + 100 >= pickBtn.tag) {
        //NSLog(@"展示");
        self.btnTag = pickBtn.tag;
        self.imageArr = [NSArray arrayWithObject:pickBtn.urlDic[@"url"]];
        if (self.lookPhotoBlock) {
            self.lookPhotoBlock();
        }
        return;
    }
    if (self.takePhotoBlock) {
        self.takePhotoBlock();
    }
}


- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic
{
    if (self.haveImageMArr.count == 3) {
        return;
    }

    ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    imageBtn.image = image;
    imageBtn.urlDic = urlDic;
    imageBtn.deleteDelegate = self;
    imageBtn.isHiddenDeleteBtn = NO;
    [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
     [self.haveImageMArr addObject:imageBtn];

    /***********************************/

    [self.urlMArr addObject:urlDic];

    [self setNeedsLayout];
}

- (void)addImageUrl:(UIImage *)image withUrl:(NSDictionary *)urlDic
{

    if (self.haveImageMArr.count == 3) {
        return;
    }

    ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
    //image.size = CGSizeMake(200, 200);


    imageBtn.image = image;
    //UIImage *myimage = [self OriginImage:image scaleToSize:CGSizeMake(200, 200)];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    imageBtn.urlDic = urlDic;
    imageBtn.deleteDelegate = self;
    imageBtn.isHiddenDeleteBtn = NO;
    [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
    [self.haveImageMArr addObject:imageBtn];


    [self setNeedsLayout];
}

-(void)setUrlMArr:(NSMutableArray *)urlMArr {
    _urlMArr = urlMArr;
//    for (NSDictionary *dic in urlMArr) {
//        [self addImageUrl:[UIImage
//                           imageWithData:[NSData
//                                          dataWithContentsOfURL:[NSURL
//                                                                 URLWithString:dic[@"url"]]]] withUrl:dic];
//    }
    [self addImageWithURLArr:_urlMArr];
}


- (void)removeALL
{
    if (self.haveImageMArr.count > 0) {
        [self.haveImageMArr removeAllObjects];
        self.haveImageMArr = nil;
    }
    if (self.btnMarr.count > 0) {
        [self.btnMarr removeAllObjects];
        self.btnMarr = nil;
    }
}

- (void)layoutSubviews
{
    if (self.haveImageMArr.count == 0) {
        self.btnMarr = [NSMutableArray arrayWithArray:self.emptyMArr];
    }
    else  {
        self.btnMarr = [NSMutableArray arrayWithArray:self.emptyMArr];
        [self.haveImageMArr enumerateObjectsUsingBlock:^(ZIKPickerBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!btn.isHiddenDeleteBtn && idx<=2) {
                [self.btnMarr replaceObjectAtIndex:idx withObject:btn];
            }
        }];
    }


    NSInteger row_nums = 3;
    CGFloat    marginX = 15;
    CGFloat imageViewW = (Width - (row_nums+1)*marginX)/row_nums;
    CGFloat imageViewH = imageViewW;

    CGFloat imageViewX = 0;
    CGFloat imageViewY = 15;

    for(NSInteger i = 0; i < self.btnMarr.count; i++)
    {
        imageViewX  = marginX + i%row_nums*(marginX + imageViewW);
        imageViewY = marginX + i/row_nums*(marginX + imageViewH);

        ZIKPickerBtn *imageView = self.btnMarr[i];
        imageView.tag = 101 + i;
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
}

#pragma mark ---------------delete Picture delegate----------

- (void)pickBtnDelete:(ZIKPickerBtn *)pickBtn
{
    pickBtn.isHiddenDeleteBtn = YES;
     [self.urlMArr removeObject:pickBtn.urlDic];
     __block  NSMutableArray *array = [NSMutableArray arrayWithArray:self.haveImageMArr];
    [self.haveImageMArr enumerateObjectsUsingBlock:^(ZIKPickerBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.image == pickBtn.image) {
            [array removeObject:btn];
        }
    }];
    [pickBtn removeFromSuperview];
    self.haveImageMArr = array;
    [self setNeedsLayout];
}

-(void)setSaveHaveImageMarr:(NSMutableArray *)saveHaveImageMarr {
    _saveHaveImageMarr = saveHaveImageMarr;
    [self addImageWithURLArr:_saveHaveImageMarr];

}

- (void)addImageWithURLArr:(NSArray *)urlArr {
    if (self.haveImageMArr.count == 3) {
        return;
    }
    [urlArr enumerateObjectsUsingBlock:^(NSDictionary *urlDic, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *urdstring=urlDic[@"compressurl"];
            ZIKPickerBtn *imageBtn = [ZIKPickerBtn buttonWithType:UIButtonTypeCustom];
            [imageBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:urlDic[@"compressurl"]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
            imageBtn.image = imageBtn.currentBackgroundImage;
            imageBtn.urlDic = urlDic;
            imageBtn.deleteDelegate = self;
            imageBtn.isHiddenDeleteBtn = NO;
            [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:imageBtn];
            [self.haveImageMArr addObject:imageBtn];
    }];

}


@end
