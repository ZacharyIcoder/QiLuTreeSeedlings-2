//
//  ZIKBaseViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

#import "ZIKBaseViewController.h"
#import "UIDefines.h"
@interface ZIKBaseViewController ()

@end

@implementation ZIKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGColor;//背景颜色
//    if (IS_IOS_7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
}

#pragma mark - 横竖屏
//横竖屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == 3)
    {
        return NO;
    }
    return NO;
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
