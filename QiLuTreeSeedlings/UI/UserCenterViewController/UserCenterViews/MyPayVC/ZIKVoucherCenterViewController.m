//
//  ZIKVoucherCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKVoucherCenterViewController.h"

#import "ZIKPaySuccessViewController.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信
#import "WXApi.h"
//银联
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"


#import "ZIKPaySuccessViewController.h"
@interface ZIKVoucherCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UPPayPluginDelegate>
@property (nonatomic, strong) UITableView *payTableView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, assign) PayWay      payway;

@end

@implementation ZIKVoucherCenterViewController
@synthesize payTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle             = @"支付订单";
    UIView *backView         = [[UIView alloc] init];
    backView.frame           = CGRectMake(0, 64, Width, Width*0.3);
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];

    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame        = CGRectMake(0, 0, Width, backView.frame.size.height);
    bgImageView.image        = [UIImage imageNamed:@"支付订单-充值金额背景"];
    [backView addSubview:bgImageView];

    UIImageView *imageview   = [[UIImageView alloc] init];
    imageview.frame          = CGRectMake(15, bgImageView.frame.size.height/2-15, 30, 30);
    imageview.image          = [UIImage imageNamed:@"支付订单48x48"];
    [bgImageView addSubview:imageview];

    UILabel *label           = [[UILabel alloc] init];
    label.frame              = CGRectMake(CGRectGetMaxX(imageview.frame)+10, imageview.frame.origin.y, 120, 26);
    label.text               = @"充值金额(元):";
    [bgImageView addSubview:label];

    UILabel *priceLabel      = [[UILabel alloc] init];
    priceLabel.frame         = CGRectMake(kWidth/2-15, label.frame.origin.y-5, kWidth/2, 35);
    priceLabel.font          = [UIFont systemFontOfSize:26];
    priceLabel.text          = [NSString stringWithFormat:@"%.2f",self.price.floatValue];
    priceLabel.textColor     = yellowButtonColor;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:priceLabel];

    payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+20, Width, 180+74) style:UITableViewStylePlain];
    payTableView.delegate   = self;
    payTableView.dataSource = self;
    payTableView.scrollEnabled = NO;
    [self.view addSubview:payTableView];
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"PaySuccessNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
}

- (void)paySuccess:(NSDictionary *)dictionary
{
    ZIKPaySuccessViewController *successVC =   [[ZIKPaySuccessViewController alloc] initWithNibName:@"ZIKPaySuccessViewController" bundle:nil];
    successVC.priceLabel.text = [NSString stringWithFormat:@"充值金额(元) : %@",self.price];
    successVC.price = self.price;
    [self.navigationController pushViewController:successVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"paycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    UIImageView *selectImageView = [[UIImageView alloc] init];
    selectImageView.frame = CGRectMake(Width-40, 17, 30, 30);
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image      = [UIImage imageNamed:@"微信支付"];
            cell.textLabel.text       = @"微信支付";
            cell.detailTextLabel.text = @"推荐安装微信5.0及以上版本的使用";
            selectImageView.image = [UIImage imageNamed:@"已选"];
        }
            break;
        case 1: {
            cell.imageView.image      = [UIImage imageNamed:@"支付宝支付"];
            cell.textLabel.text       = @"支付宝支付";
            cell.detailTextLabel.text = @"推荐有支付宝账号的用户使用";
            selectImageView.image = [UIImage imageNamed:@"待选"];
        }
            break;
        case 2: {
            cell.imageView.image      = [UIImage imageNamed:@"银联支付"];
            cell.textLabel.text       = @"银联支付";
            cell.detailTextLabel.text = @"安全快捷的支付方式";
            selectImageView.image = [UIImage imageNamed:@"待选"];
        }
            break;
        default:
            break;
    }
    float sw = 31/cell.imageView.image.size.width;
    float sh = 31/cell.imageView.image.size.height;
    cell.imageView.transform = CGAffineTransformMakeScale(sw,sh);
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    selectImageView.tag   = 1000;
    [cell addSubview:selectImageView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = self.view.backgroundColor;
    if (0 == section)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:btn];
        btn.frame = CGRectMake(40, 15, Width-80, 44);
        [btn setBackgroundColor:yellowButtonColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:@"确认支付" forState:UIControlStateNormal];
        //btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(sureButtonPress) forControlEvents:UIControlEventTouchUpInside];
    }

    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath ==  self.lastIndexPath && self.lastIndexPath != [NSIndexPath indexPathForRow:0 inSection:0]) {
        return;
    }

    UITableViewCell *lastCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:self.lastIndexPath];
    UIImageView *lastCheckImageView = (UIImageView *)[lastCell viewWithTag:1000];
    [lastCheckImageView setImage:[UIImage imageNamed:@"待选"]];

    UITableViewCell *Cell =[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkImageView = (UIImageView *)[Cell viewWithTag:1000];
    [checkImageView setImage:[UIImage imageNamed:@"已选"]];

    self.lastIndexPath = indexPath;
    //UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)sureButtonPress {
//    ZIKPaySuccessViewController *paySuccessVC = [[ZIKPaySuccessViewController alloc] init];
//    [self.navigationController pushViewController:paySuccessVC animated:YES];
    
    if (self.lastIndexPath.row == 0) {
        //NSLog(@"微信支付");
        [HTTPCLIENT weixinPayOrder:self.price Success:^(id responseObject) {
            //NSLog(@"%@",responseObject);
            NSDictionary *dict = responseObject[@"result"];
            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];//商户号
                req.prepayId            = [dict objectForKey:@"prepayid"];//预支付交易ID
                req.nonceStr            = [dict objectForKey:@"noncestr"];//随机字符串
                req.timeStamp           = stamp.intValue;//时间戳
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];

                [WXApi sendReq:req];

            }
            else {
                //NSLog(@"%@",responseObject[@"msg"]);
            }
        } failure:^(NSError *error) {

        }];
    }
    else if (self.lastIndexPath.row == 1) {
        //NSLog(@"支付宝支付");
        
        [ZIKFunction zhiFuBao:self name:@"苗木充值" titile:@"苗木充值" price:self.price orderId:APPDELEGATE.userModel.access_id];
    }
    else if (self.lastIndexPath.row == 2) {
        //NSLog(@"银联支付");
        [ToastView showToast:@"银联支付暂未开通" withOriginY:Width/3 withSuperView:self.view];
        return;
        //[self getUPPay];
//        [HTTPCLIENT weixinPayOrder:@"0.01" Success:^(id responseObject) {
//            NSLog(@"%@",responseObject);
//            if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
//                NSString *  tnSring = [responseObject[@"result"] objectForKey:@"tn"];
//                NSLog(@"tnSring= %@",tnSring);
//                [UPPayPlugin startPay:tnSring mode:@"00" viewController:self delegate:self];
//
//            }
//            else {
//                NSLog(@"%@",responseObject[@"msg"]);
//            }
//            //return [responseObject[@"result"] objectForKey:@"tn"];
//        } failure:^(NSError *error) {
//            
//        }];
        [HTTPCLIENT getUnioPayTnString:@"0.01" Success:^(id responseObject) {
            //NSLog(@"%@",responseObject);
        } failure:^(NSError *error) {

        }];


    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void )getUPPay{
   //__block NSString *tnSring = nil;
    [HTTPCLIENT getUnioPay:@"0.01" Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
          NSString *  tnSring = [responseObject[@"result"] objectForKey:@"tn"];
            //NSLog(@"tnSring= %@",tnSring);
            [UPPayPlugin startPay:tnSring mode:@"00" viewController:self delegate:self];

        }
        else {
            //NSLog(@"%@",responseObject[@"msg"]);
        }
     //return [responseObject[@"result"] objectForKey:@"tn"];
    } failure:^(NSError *error) {

    }];
    //return tnSring;
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    //NSLog(@"%@",result);
    if ([result isEqualToString:@"success"]) {
        //[self paySuccess:nil];
    }
    else if ([result isEqualToString:@"fail"]) {
        //[XtomFunction openIntervalHUD:@"支付失败" view:nil];
        return;
    }
    else if ([result isEqualToString:@"cancel"]) {
        //[XtomFunction openIntervalHUD:@"取消支付" view:nil];
        return;
    }
    //    NSString* msg = [NSString stringWithFormat:kResult, result];
    //    [self showAlertMessage:msg];
}


@end
