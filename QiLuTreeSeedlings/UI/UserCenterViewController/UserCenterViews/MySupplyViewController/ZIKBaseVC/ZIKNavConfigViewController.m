//
//  ZIKNavConfigViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKNavConfigViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"//button扩展点击区域
#import "ZIKFunction.h"

#define titleFont [UIFont systemFontOfSize:20]//标题字体Font20o
#define navButtonFont [UIFont systemFontOfSize:16]//navButton字体大小
#define navButtonFontSize 16
#define leftButtonX 17
#define leftButtonY 26
#define leftButtonH 30
@interface ZIKNavConfigViewController ()

@end

@implementation ZIKNavConfigViewController
{
    @private
    UILabel  *titleLable;//标题lable
    UIButton *leftButton;//nav左侧按钮
    UIButton *rightButton;//nav右侧按钮
    UIView *navBackView;
}
-(id)init
{
    self=[super init];
    if (self) {
       [self makeNavView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

#pragma mark - 设置navView
- (void)makeNavView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    [self.view addSubview:view];
    navBackView=view;
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(leftButtonX, leftButtonY, 30, leftButtonH)];
    leftButton.titleLabel.font = navButtonFont;
//    [leftButton setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [leftButton setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-50, leftButtonY, 40, leftButtonH)];
    [rightButton setEnlargeEdgeWithTop:15 right:30 bottom:10 left:30];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-100,26, 200, 30)];
    [titleLable setTextColor:[UIColor whiteColor]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setFont:titleFont];
    [view addSubview:titleLable];
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

#pragma mark - 设置右侧按钮文字
-(void)setRightBarBtnTitleString:(NSString *)rightBarBtnTitleString {
    _rightBarBtnTitleString = rightBarBtnTitleString;
    [rightButton setTitle:rightBarBtnTitleString forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setImage:nil forState:UIControlStateNormal];
    [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    CGFloat rightWidth = [ZIKFunction getCGRectWithContent:rightBarBtnTitleString width:180 font:navButtonFontSize].size.width;
    rightButton.frame = CGRectMake(kWidth-10-rightWidth-25, leftButtonY, rightWidth+25, leftButtonH);
}

#pragma mark - 设置右侧图像
-(void)setRightBarBtnImgString:(NSString *)rightBarBtnImgString {
    _rightBarBtnImgString = rightBarBtnImgString;
    [rightButton setTitle:nil forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(kWidth-45, leftButtonY, 30, 30);
    [rightButton setImage:[UIImage imageNamed:rightBarBtnImgString] forState:UIControlStateNormal];
}
#pragma mark - 设置背景颜色
-(void)setBackColor:(UIColor *)backColor
{
    _backColor=backColor;
    [navBackView setBackgroundColor:backColor];
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

//处理右侧的block回调
#pragma mark ---------------处理右侧的block回调-----------------
- (void)rightBtnClicked:(UIButton *)button
{
    if (self.rightBarBtnBlock) {
        self.rightBarBtnBlock();
    }
    //默认暂时没处理，有需要加上
}

#pragma mark -低内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
