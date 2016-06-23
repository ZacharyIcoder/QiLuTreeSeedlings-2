//
//  ZIKSingleVoucherCenterViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
typedef NS_ENUM(NSUInteger, PayWay) {
    Pay_Online,     //在线支付
    Pay_ZhifuBao,   //支付宝
    Pay_WeiXin,     //微信支付
    Pay_YuE,        //余额支付
};

@interface ZIKSingleVoucherCenterViewController : ZIKArrowViewController
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *buyUid;

@end
