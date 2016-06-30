//
//  ZIKSingleVoucherCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKSingleVoucherCenterViewController.h"
#import "StringAttributeHelper.h"
#import "BuyMessageAlertView.h"
#import "ZIKPayViewController.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信
#import "WXApi.h"
//银联
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
@interface ZIKSingleVoucherCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UPPayPluginDelegate>
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, assign) PayWay      payway;
@property (weak, nonatomic  ) IBOutlet UILabel     *priceLabel;
@property (weak, nonatomic  ) IBOutlet UITableView *payTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTableTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureButtonBottomLayoutConstraint;
@property (nonatomic,weak)BuyMessageAlertView *buyAlertView;

@end

@implementation ZIKSingleVoucherCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"支付";
    if (iPhone35Inch) {
        self.payTableTopLayout.constant = 5;
        self.sureButtonBottomLayoutConstraint.constant = 5;
    }
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"SinglePaySuccessNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinglePaySuccessNotification" object:nil];
}

- (void)paySuccess:(NSDictionary *)dictionary
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.payTableView.delegate   = self;
    self.payTableView.dataSource = self;
    _payTableView.scrollEnabled  = NO;

    NSString *priceStr = [NSString stringWithFormat:@"所需费用 %.2f元",self.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:18.0f];
    fullFont.effectRange  = NSMakeRange(0, priceStr.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = DarkTitleColor;
    fullColor.effectRange = NSMakeRange(0,priceStr.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:18.0f];
    partFont.effectRange = NSMakeRange(4, priceStr.length-4);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(4, priceStr.length-4);

    self.priceLabel.attributedText = [priceStr mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    selectImageView.frame = CGRectMake(Width-40, 19, 22, 22);
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image      = [UIImage imageNamed:@"logV"];
            cell.textLabel.text       = @"苗信通支付";
            cell.detailTextLabel.text = @"直接使用账户余额进行支付";
            selectImageView.image = [UIImage imageNamed:@"已选小标"];
        }
            break;
        case 1:
        {
            cell.imageView.image      = [UIImage imageNamed:@"微信支付"];
            cell.textLabel.text       = @"微信支付";
            cell.detailTextLabel.text = @"推荐安装微信5.0及以上版本的使用";
            selectImageView.image = [UIImage imageNamed:@"待选"];
        }
            break;
        case 2: {
            cell.imageView.image      = [UIImage imageNamed:@"支付宝支付"];
            cell.textLabel.text       = @"支付宝支付";
            cell.detailTextLabel.text = @"推荐有支付宝账号的用户使用";
            selectImageView.image = [UIImage imageNamed:@"待选"];
        }
            break;
        case 3: {
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
    [checkImageView setImage:[UIImage imageNamed:@"已选小标"]];

    self.lastIndexPath = indexPath;
    //UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    /*  [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
     if ([[responseObject objectForKey:@"success"] integerValue]) {
     float moneyNum =[[[responseObject objectForKey:@"result"] objectForKey:@"money"]floatValue];
     if (moneyNum<self.model.buyPrice) {
     [ToastView showTopToast:@"您的余额不足，请先充值"];

     ZIKPayViewController *zikPayVC=[[ZIKPayViewController alloc]init];
     [self.navigationController pushViewController:zikPayVC animated:YES];
     return ;
     }
     _buyAlertView =[BuyMessageAlertView addActionVieWithPrice:[NSString stringWithFormat:@"%.2f",self.model.buyPrice               ] AndMone:[NSString stringWithFormat:@"%.2f",moneyNum]];
     [_buyAlertView.rightBtn addTarget:self action:@selector(buySureAction) forControlEvents:UIControlEventTouchUpInside];
     }else{
     [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
     }
     } failure:^(NSError *error) {

     }];
     }

     -(void)buySureAction
     {
     ShowActionV();
     [HTTPCLIENT payForBuyMessageWithBuyUid:self.model.uid Success:^(id responseObject) {
     RemoveActionV();
     if ([[responseObject objectForKey:@"success"] integerValue]) {
     [ToastView showTopToast:@"购买成功"];*/
    if (self.lastIndexPath.row == 0) {
        [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                float moneyNum = [[[responseObject objectForKey:@"result"] objectForKey:@"money"]floatValue];
                APPDELEGATE.userModel.balance = [NSString stringWithFormat:@"%.2f",moneyNum];
                if (moneyNum < self.price) {
//                    [ToastView showTopToast:@"您的余额不足，请先充值"];
                    _buyAlertView = [BuyMessageAlertView addActionVieWithMoney:[NSString stringWithFormat:@"%.2f",moneyNum]];
                   [_buyAlertView.rightBtn addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];

//                    ZIKPayViewController *zikPayVC=[[ZIKPayViewController alloc]init];
//                    [self.navigationController pushViewController:zikPayVC animated:YES];
                   return ;
              }
                APPDELEGATE.isFromSingleVoucherCenter = NO;
//                _buyAlertView = [BuyMessageAlertView addActionVieWithPrice:[NSString stringWithFormat:@"%.2f",self.price               ] AndMone:[NSString stringWithFormat:@"%.2f",moneyNum]];
                 _buyAlertView = [BuyMessageAlertView addActionVieWithMoney:[NSString stringWithFormat:@"%.2f",moneyNum] withPrice:[NSString stringWithFormat:@"%.2f",self.price]];
                [_buyAlertView.rightBtn addTarget:self action:@selector(payYue) forControlEvents:UIControlEventTouchUpInside];
//                [self payYue];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                return;
            }
        } failure:^(NSError *error) {
            
        }];

        return;
    }
    if (self.lastIndexPath.row == 1) {
        if(![WXApi isWXAppInstalled]) {
            [ToastView showTopToast:@"您还未安装微信!"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [ToastView showTopToast:@"当前微信版本过低,请升级微信后再次充值"];
            return;
        }
        APPDELEGATE.isFromSingleVoucherCenter = NO;
        //NSLog(@"微信支付");
        NSString *pricesting = [NSString stringWithFormat:@"%f",self.price];
        [HTTPCLIENT weixinPayOrder:pricesting supplyBuyUid:self.buyUid type:@"1" Success:^(id responseObject) {
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
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
        } failure:^(NSError *error) {

        }];
    }
    else if (self.lastIndexPath.row == 2) {
        //NSLog(@"支付宝支付");
        APPDELEGATE.isFromSingleVoucherCenter = NO;
    NSString *pricesting = [NSString stringWithFormat:@"%.2f",self.price];
        [ZIKFunction zhiFuBao:self name:@"苗木充值" titile:@"苗木充值" price:pricesting orderId:APPDELEGATE.userModel.access_id supplyBuyUid:self.buyUid type:@"1"];
    }
    else if (self.lastIndexPath.row == 3) {
        //NSLog(@"银联支付");
        APPDELEGATE.isFromSingleVoucherCenter = NO;
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

- (void)payYue {
    [BuyMessageAlertView removeActionView];
    ShowActionV();
   [HTTPCLIENT payForBuyMessageWithBuyUid:self.buyUid Success:^(id responseObject) {
    RemoveActionV();
    if ([[responseObject objectForKey:@"success"] integerValue]) {
        [ToastView showTopToast:@"购买成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        return ;
    }
  } failure:^(NSError *error) {
      RemoveActionV();
  }];

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

- (void)chongzhi {
    [BuyMessageAlertView removeActionView];
    APPDELEGATE.isFromSingleVoucherCenter = YES;
    ZIKPayViewController *payVC = [[ZIKPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}
@end
