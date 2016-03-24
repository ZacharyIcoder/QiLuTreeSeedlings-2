//
//  ZIKRightBtnSringViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface ZIKRightBtnSringViewController ()
{
    @private
    UIButton *backBtn;
}
@end

@implementation ZIKRightBtnSringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    backBtn=[[UIButton alloc]initWithFrame:CGRectMake(Width-50, 26, 40, 30)];
    //backBtn.backgroundColor = [UIColor redColor];
    //[backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setTitle:self.rightBarBtnTitleString forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

//设置右侧按钮
#pragma mark ---------------设置右侧按钮-----------------
- (void)setRightBarBtnTitleString:(NSString *)rightBarBtnTitleString
{
    _rightBarBtnTitleString = rightBarBtnTitleString;
    [backBtn setTitle:self.rightBarBtnTitleString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
