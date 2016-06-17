//
//  ZIKBaseChangeNavViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKBaseChangeNavViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "ZIKSearchBarView.h"
#import "ZIKFunction.h"

#define titleFont [UIFont systemFontOfSize:20]//标题字体Font20o
#define navButtonFont [UIFont systemFontOfSize:16]//navButton字体大小
#define navButtonFontSize 16
#define leftButtonX 15
#define leftButtonY 26
#define leftButtonH 30

@interface ZIKBaseChangeNavViewController ()

@end

@implementation ZIKBaseChangeNavViewController
{
@private
    UILabel  *titleLable;//标题lable
    UIButton *leftButton;//nav左侧按钮
    UIButton *rightButton;//nav右侧按钮

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNavView];
    self.isSearch = NO;
}

- (void)initNavView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    [self.view addSubview:view];

    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(leftButtonX, leftButtonY, 30, leftButtonH)];
    leftButton.titleLabel.font = navButtonFont;
    //    [leftButton setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [leftButton setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-40, leftButtonY+2, 25, 25)];
//    [rightButton setEnlargeEdgeWithTop:15 right:30 bottom:10 left:30];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:rightButton];
    [rightButton setImage:[UIImage imageNamed:@"ico_顶部搜索"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-100,26, 200, 30)];
    [titleLable setTextColor:[UIColor whiteColor]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setFont:titleFont];
    [view addSubview:titleLable];

    ZIKSearchBarView *searchBarView = [[ZIKSearchBarView alloc] initWithFrame:CGRectMake(60, 25, kWidth-60-20, 30)];
    [view addSubview:searchBarView];
    self.searchBarView = searchBarView;

}

-(void)setIsSearch:(BOOL)isSearch {
    _isSearch = isSearch;
    _isSearch ? (self.searchBarView.hidden = NO , rightButton.hidden = YES) : (self.searchBarView.hidden = YES, rightButton.hidden = NO);
}

#pragma mark - 设置左侧按钮文字
-(void)setLeftBarBtnTitleString:(NSString *)leftBarBtnTitleString {
    _leftBarBtnTitleString = leftBarBtnTitleString;
    [leftButton setImage:nil forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(leftButtonX, leftButtonY, [ZIKFunction getCGRectWithContent:leftBarBtnTitleString width:100 font:navButtonFontSize].size.width, 30);
    [leftButton setTitle:leftBarBtnTitleString forState:UIControlStateNormal];
}

#pragma mark - 设置左侧按钮图像
-(void)setLeftBarBtnImgString:(NSString *)leftBarBtnImgString {
    _leftBarBtnImgString = leftBarBtnImgString;
    [leftButton setTitle:nil forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(leftButtonX, leftButtonY, 30, 30);
    [leftButton setImage:[UIImage imageNamed:leftBarBtnImgString] forState:UIControlStateNormal];
}

#pragma mark - 设置标题
-(void)setVcTitle:(NSString *)vcTitle {
    _vcTitle = vcTitle;
    titleLable.text = vcTitle;
}

//处理左侧block回调，以及默认操作是返回上一层
#pragma mark ---------------处理block回调,默认操作是返回上一层-----------------
- (void)leftBtnClicked:(UIButton *)button
{
    if (self.leftBarBtnBlock) {
        self.leftBarBtnBlock();
    }else //默认返回上一层
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 设置右侧按钮文字
-(void)setRightBarBtnTitleString:(NSString *)rightBarBtnTitleString {
    _rightBarBtnTitleString = rightBarBtnTitleString;
    [rightButton setImage:nil forState:UIControlStateNormal];
    CGFloat rightWidth = [ZIKFunction getCGRectWithContent:rightBarBtnTitleString width:100 font:navButtonFontSize].size.width;
    rightButton.frame = CGRectMake(kWidth-10-rightWidth, leftButtonY, rightWidth, leftButtonH);
}

#pragma mark - 设置右侧图像
-(void)setRightBarBtnImgString:(NSString *)rightBarBtnImgString {
    _rightBarBtnImgString = rightBarBtnImgString;
    [rightButton setTitle:nil forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(kWidth-45, leftButtonY, 30, 30);
    [rightButton setImage:[UIImage imageNamed:rightBarBtnImgString] forState:UIControlStateNormal];
}

//处理右侧的block回调
#pragma mark ---------------处理右侧的block回调-----------------
- (void)rightBtnClicked:(UIButton *)button
{
    if (self.rightBarBtnBlock) {
        self.rightBarBtnBlock();
    }
    //默认暂时没处理，有需要加上
    else {
        self.isSearch = !self.isSearch;
//        _isSearch ? (rightButton.hidden = YES) : (rightButton.hidden = NO);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
