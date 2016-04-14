//
//  BigImageViewShowView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BigImageViewShowView.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@interface BigImageViewShowView ()
@property (nonatomic,strong) UIScrollView *backScrollView;
@end

@implementation BigImageViewShowView
-(id)initWithImageAry:(NSArray *)imageAry
{
    self=[super init];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        _backScrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:_backScrollView];
        [_backScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [_backScrollView setContentSize:CGSizeMake(kWidth*imageAry.count, 0)];
        _backScrollView.pagingEnabled=YES;
        for (int i=0; i<imageAry.count; i++) {
            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth,230)];
            imageV.center=CGPointMake(kWidth*i+kWidth/2, kHeight/2-20);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageAry[i]]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            __weak typeof(imageV) weakimageV = imageV;
            [imageV setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"MoRentu"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                [weakimageV setImage:image];
               // NSLog(@"%lf--%lf",image.size.width,image.size.height);
               float scanl = (float)kWidth/image.size.width;
                CGFloat imagheight=(CGFloat)image.size.height*scanl;
                CGRect tempFrame=weakimageV.frame;
                tempFrame.size.height=imagheight;
                weakimageV.frame=tempFrame;
                weakimageV.center=CGPointMake(kWidth*i+kWidth/2, kHeight/2);
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
            [_backScrollView addSubview:imageV];
          
        }
          self.hidden=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidingSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)hidingSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}
-(void)showWithIndex:(NSInteger)index
{
    [_backScrollView setContentOffset:CGPointMake(kWidth*index, 0)];
    self.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
