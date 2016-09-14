//
//  ZIKShaiDanPickImageView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击添加按钮之后调用的block

typedef void(^TakePhotoBlock) ();

@interface ZIKShaiDanPickImageView : UIView
- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic;
- (void)removeImage:(UIImage *)image;
- (void)addImageURL:(NSDictionary *)dic;
- (void)removeImageURl:(NSDictionary *)dic;
- (void)removeALL;
- (void)initUI;
@property(nonatomic, copy) TakePhotoBlock takePhotoBlock;

@property(nonatomic, strong) NSMutableArray *photos;

@property(nonatomic, strong) NSMutableArray *urlMArr;
@end
