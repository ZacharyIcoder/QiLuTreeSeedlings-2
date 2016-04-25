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
#define kActionVTag 18888
@interface BigImageViewShowView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,  strong) UIPageControl *pageController;
@end

@implementation BigImageViewShowView
-(id)initWithImageAry:(NSArray *)imageAry
{
    self=[super init];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        _backScrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backScrollView.delegate=self;
        [self addSubview:_backScrollView];
        [_backScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [_backScrollView setContentSize:CGSizeMake(kWidth*imageAry.count, 0)];
        _backScrollView.pagingEnabled=YES;
        _backScrollView.showsHorizontalScrollIndicator = NO;
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
        CGRect pageFrame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:pageFrame];
        [pageController setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self addSubview:pageController];
        pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:107/255.0f green:188/255.0f blue:85/255.0f alpha:1.0f];
        
        pageController.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageController = pageController;
        [pageController setNumberOfPages:[imageAry count]];

    }
    return self;
}
-(id)initWithNomalImageAry:(NSArray *)imageAry
{
    self=[super init];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        _backScrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backScrollView.delegate=self;
        [self addSubview:_backScrollView];
        [_backScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.33]];
        [_backScrollView setContentSize:CGSizeMake(kWidth*imageAry.count, 0)];
        _backScrollView.pagingEnabled=YES;
         _backScrollView.showsHorizontalScrollIndicator = NO;
        for (int i=0; i<imageAry.count; i++) {
            UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, kWidth-30,(kWidth-30)*1.77778)];
            [imageV setImage:[UIImage imageNamed:imageAry[i]]];
            imageV.center=CGPointMake(kWidth*i+kWidth/2, kHeight/2);
            [_backScrollView addSubview:imageV];
            
        }
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromeKeyWind)];
        [self addGestureRecognizer:tap];
        
        CGRect pageFrame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:pageFrame];
        [pageController setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.33]];
        [self addSubview:pageController];
        pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:107/255.0f green:188/255.0f blue:85/255.0f alpha:1.0f];
        
        pageController.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageController = pageController;
        [pageController setNumberOfPages:[imageAry count]];
    }
    return self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     CGFloat  viewWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger offset = scrollView.contentOffset.x/viewWidth;
    self.pageController.currentPage = offset;
//    if (scrollView.contentOffset.x >= (scrollView.contentSize.width-1.5*viewWidth)) {
//        [scrollView setContentOffset:CGPointMake(viewWidth, 0)];
//        self.pageController.currentPage =scrollView.contentOffset.x/viewWidth-1;
//    }
//    if (scrollView.contentOffset.x<=0.5*viewWidth) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-2*viewWidth, 0)];
//        self.pageController.currentPage = scrollView.contentOffset.x/viewWidth-1;
//    }
}
-(void)hidingSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}
-(void)removeFromeKeyWind
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)showInKeyWindowWithIndex:(NSInteger)index
{
    [_backScrollView setContentOffset:CGPointMake(kWidth*index, 0)];
    self.pageController.currentPage=index;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
        
    }];

}
-(void)showWithIndex:(NSInteger)index
{
    [_backScrollView setContentOffset:CGPointMake(kWidth*index, 0)];
    self.hidden=NO;
    self.pageController.currentPage=index;
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
