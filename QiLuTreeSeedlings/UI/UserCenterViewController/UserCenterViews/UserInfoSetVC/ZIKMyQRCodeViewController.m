//
//  ZIKMyQRCodeViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyQRCodeViewController.h"
#import "UIView+KMJExtension.h"
#import "NSString+Helper.h"
#import "HttpDefines.h"
@interface ZIKMyQRCodeViewController ()

@end

@implementation ZIKMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"我的二维码";

    //NSString *qrCodeString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];//http://www.qlhm.cn:8081/qlmm/
//    NSString *qrCodeString = [NSString stringWithFormat:@"http://www.qlhm.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];//http://www.qlhm.cn:8081/qlmm/
    //http://www.qlhm.cn:8081/qlmm/
    //http://a.app.qq.com/o/simple.jsp?pkgname=com.zhongyi.nurserystock
     NSString *qrCodeString = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.zhongyi.nurserystock";


    UIImageView *qrCodeImageView = [[UIImageView alloc] init];
    qrCodeImageView.frame = CGRectMake(20, Height/4, Width-40, Height/2);
    [self.view addSubview:qrCodeImageView];
    UIImage *image = [qrCodeString createRRcode];
    qrCodeImageView.image = image;

    UIImageView *logoImageView = [[UIImageView alloc] init];
    //logoImageView.frame = CGRectMake(CGRectGetMidX(qrCodeImageView.frame)-10, CGRectGetMidY(qrCodeImageView.frame)-10, 20, 20);
    logoImageView.frame = CGRectMake(qrCodeImageView.frame.size.width/2-20, qrCodeImageView.frame.size.height/2-20, 40, 40);

    logoImageView.image = [UIImage imageNamed:@"logV"];
    [qrCodeImageView addSubview:logoImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
