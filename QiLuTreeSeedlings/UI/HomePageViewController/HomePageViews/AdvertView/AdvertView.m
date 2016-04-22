//
//  AdvertView.m
//  baba88
//
//  Created by JCAI on 15/7/20.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "AdvertView.h"
@interface AdvertView () <UIScrollViewDelegate>

@property (nonatomic,  strong) UIScrollView *scrollView;
@property (nonatomic,  strong) UIPageControl *pageController;
@property (nonatomic,  strong) NSTimer *timer;

@end


@implementation AdvertView

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize pageController = _pageController;
@synthesize timer = _timer;


- (void)dealloc
{
    self.delegate = nil;
    self.scrollView = nil;
    self.pageController = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor greenColor]];
        
        CGRect scrollFrame = CGRectMake(0  , 0, frame.size.width, frame.size.height);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.delegate = self;
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        CGRect pageFrame = CGRectMake(0, scrollFrame.size.height-20, self.frame.size.width, 20);
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:pageFrame];
        [pageController setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0 ]];
        [self addSubview:pageController];
        pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:107/255.0f green:188/255.0f blue:85/255.0f alpha:1.0f];
        
        pageController.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageController = pageController;
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger offset = self.scrollView.contentOffset.x/viewWidth-1;
    self.pageController.currentPage = offset;
    if (self.scrollView.contentOffset.x >= (self.scrollView.contentSize.width-1.5*viewWidth)) {
        [self.scrollView setContentOffset:CGPointMake(viewWidth, 0)];
        self.pageController.currentPage = self.scrollView.contentOffset.x/viewWidth-1;
    }
    if (self.scrollView.contentOffset.x<=0.5*viewWidth) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-2*viewWidth, 0)];
        self.pageController.currentPage = scrollView.contentOffset.x/viewWidth-1;
    }
}

- (void)setAdInfo
{
    
    NSArray *imageAry= @[@"bannelSmall1.jpg", @"bannelSmall2.jpg",@"bannelSmall3.jpg", @"bannelSmall4.jpg"];
    [self.pageController setNumberOfPages:[imageAry count]];
    CGRect imageFrame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    imageFrame.origin = CGPointZero;
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [firstImageView setImage:[UIImage imageNamed:[imageAry lastObject]]];
    
    [self.scrollView addSubview:firstImageView];
    imageFrame.origin.x += imageFrame.size.width;
    
   
    for (int i =0;  i<imageAry.count; i++) {
        NSString *image=imageAry[i];
        UIButton *button = [[UIButton alloc] initWithFrame:imageFrame];
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        //[button setTag:tag];
        [self.scrollView addSubview:button];
        [button setTag:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [imageView setImage:[UIImage imageNamed:image]];
        [self.scrollView addSubview:imageView];
        
        imageFrame.origin.x += imageFrame.size.width;
        
    }
    
    UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [lastImageView setImage:[UIImage imageNamed:[imageAry firstObject]]];
    [self.scrollView addSubview:lastImageView];

    [self.scrollView setContentSize:CGSizeMake(imageFrame.size.width*([imageAry count]+2),
                                               0)];
    [self.scrollView setContentOffset:CGPointMake(imageFrame.size.width, 0)];
}

#pragma mark - 
#pragma mark -
- (void)changeTime
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSInteger page = self.pageController.numberOfPages;
    NSInteger currentPage = self.pageController.currentPage;
    CGPoint scrollOffset = self.scrollView.contentOffset;
    CGFloat scrollWidth = self.scrollView.frame.size.width;
    currentPage ++;
    scrollOffset.x = scrollWidth * (currentPage+1);
    
    if (currentPage >= page) {
        self.pageController.currentPage = 0;
        [self.scrollView setContentOffset:CGPointMake(scrollWidth, 0) animated:YES];
    }
    else {
        self.pageController.currentPage = currentPage;
        [self.scrollView setContentOffset:scrollOffset animated:YES];
    }
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(changeTime)
                                                userInfo:nil
                                                 repeats:NO];
}


- (void)buttonClicked:(UIButton *)button
{
    NSInteger tag = button.tag;
        if ([self.delegate respondsToSelector:@selector(advertPush:)]) {
            [self.delegate advertPush:tag];
        }
    
}


- (void)adStart
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(changeTime)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)adStop
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
