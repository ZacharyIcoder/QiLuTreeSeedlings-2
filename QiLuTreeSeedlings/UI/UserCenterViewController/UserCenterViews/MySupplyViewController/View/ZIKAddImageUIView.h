//
//  ZIKAddImageUIView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>


//点击添加按钮之后调用的block

typedef void(^TakePhotoBlock) ();

@interface ZIKAddImageUIView : UIView

- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic;
- (void)removeImage:(UIImage *)image;
- (void)addImageURL:(NSDictionary *)dic;
- (void)removeImageURl:(NSDictionary *)dic;
- (void)removeALL;

@property(nonatomic, copy) TakePhotoBlock takePhotoBlock;

@property(nonatomic, strong) NSMutableArray *photos;

@property(nonatomic, strong) NSMutableArray *urlMArr;

@property (nonatomic, assign) NSInteger btnNum;
@end
