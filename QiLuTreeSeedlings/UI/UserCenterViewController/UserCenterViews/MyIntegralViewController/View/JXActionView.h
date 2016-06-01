//
//  ActionView.h
//  RongQingSchool
//
//  Created by caitong on 15/8/31.
//  Copyright (c) 2015年 荣庆通达驾校. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionClickIndexBlock)(NSInteger index);

@interface JXActionView : UIView

@property(strong,nonatomic) NSString *title;

@property(strong,nonatomic) NSString *leftBtnTitle;

@property(strong,nonatomic) NSString *rightBtnTitle;

@property(strong,nonatomic) IBOutlet UILabel *titleLb;

@property(strong,nonatomic) IBOutlet UILabel *descLb;

@property(strong,nonatomic) IBOutlet UIButton *leftBtn;

@property(strong,nonatomic) IBOutlet UIButton *rightBtn;

@property(strong,nonatomic) IBOutlet UIImageView *horPic;

@property(strong,nonatomic) IBOutlet UIImageView *verPic;

@property(strong,nonatomic) ActionClickIndexBlock clickBlock;

-(void)addClickBlock:(ActionClickIndexBlock)block;

@end
