//
//  ZIKAddImageView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define oneBtnTag   101
#define twoBtnTag   102
#define threeBtnTag 103

//点击添加按钮之后调用的block
//typedef void(^TakePhotoBlock) (NSInteger);
typedef void(^TakePhotoBlock) ();

typedef void (^LookPhotoBlock) ();

@interface ZIKAddImageView : UIView

- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic;

/**
 *  添加图片block
 */
@property (nonatomic, copy  ) TakePhotoBlock takePhotoBlock;
/**
 *  展示图片block
 */
@property (nonatomic, copy  ) LookPhotoBlock lookPhotoBlock;

/**
 *  图片的url数组
 */
@property (nonatomic, strong) NSMutableArray *urlMArr;
/**
 *  保存的已添加的图片
 */
@property (nonatomic, strong) NSMutableArray *saveHaveImageMarr;
/**
 *  添加的图片
 */
@property (nonatomic, strong) NSMutableArray *haveImageMArr;
/**
 *  三张默认图片
 */
@property (nonatomic, strong) NSArray        *emptyMArr;
/**
 *  添加的图片和三张默认图片组合成的图片数组
 */
@property (nonatomic, strong) NSMutableArray *btnMarr;
/**
 *  标记点击的Btn
 */
@property (nonatomic, assign) NSInteger      btnTag;
/**
 *  展示大图URL数组
 */
@property (nonatomic, strong) NSArray        *imageArr;
@end
