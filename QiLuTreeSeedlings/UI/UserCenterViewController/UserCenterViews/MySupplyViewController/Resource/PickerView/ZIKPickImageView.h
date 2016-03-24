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


- (void)addImage:(UIImage *)image;
- (void)removeImage:(UIImage *)image;


@property(nonatomic, copy) TakePhotoBlock takePhotoBlock;

@property(nonatomic, strong) NSMutableArray *photos;

@end