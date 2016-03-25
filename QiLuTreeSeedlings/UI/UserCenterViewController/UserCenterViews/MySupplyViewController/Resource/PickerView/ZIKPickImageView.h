//
//  PickImageView.h
//
//  Created by Apple on 15/10/9.
//  Copyright (c) 2015年 ShanDongSanMi. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击添加按钮之后调用的block

typedef void(^TakePhotoBlock) ();


@interface ZIKPickImageView: UIView


- (void)addImage:(UIImage *)image withUrl:(NSDictionary *)urlDic;
- (void)removeImage:(UIImage *)image;
- (void)addImageURL:(NSDictionary *)dic;
- (void)removeImageURl:(NSDictionary *)dic;

@property(nonatomic, copy) TakePhotoBlock takePhotoBlock;

@property(nonatomic, strong) NSMutableArray *photos;

@property(nonatomic, strong) NSMutableArray *urlMArr;
@end