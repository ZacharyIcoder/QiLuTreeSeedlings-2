//
//  WeiboImageBrowser.h
//  MySinaWeibo
//
//  Created by 刘刘智明 on 16/8/20.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboImageBrowser : UIView<UIScrollViewDelegate>

//@property (nonatomic, copy) NSArray *imageViewArray;

@property (nonatomic, assign) int currentSelectedIamge;

@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@property (nonatomic, strong) UILabel *pageIndexLabel;

@property (nonatomic,strong) NSMutableArray *originRects;

@property (nonatomic, copy) NSArray *bigImageArray;

- (instancetype)initWithFrame : (CGRect)rect;

- (void)showWeiboImages;

@end
