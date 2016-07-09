//
//  ZIKMyShopViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyShopViewController.h"
#import "UIWebView+AFNetworking.h"
@interface ZIKMyShopViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *shopWebView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation ZIKMyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLable.text = @"我的店铺";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.memberUid = APPDELEGATE.userModel.access_id;
    NSString  *urlString = [NSString stringWithFormat:@"http://192.168.1.9?memberUid=%@&appMemberUid=%@&title=1",_memberUid,APPDELEGATE.userModel.access_id];
    //NSString *baidu = @"https://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.shopWebView loadRequest:request];
}

- (IBAction)backButtonClick:(UIButton *)sender {
    if ([self.shopWebView canGoBack]) {
        [self.shopWebView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    CLog(@"分享");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
