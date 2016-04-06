//
//  ZIKVoucherCenterViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//
#import "ZIKArrowViewController.h"
typedef NS_ENUM(NSUInteger, PayWay) {
    Pay_Online,     //在线支付
    Pay_ZhifuBao,   //支付宝
    Pay_WeiXin,     //微信支付
    Pay_YuE,        //余额支付
};

@interface ZIKVoucherCenterViewController : ZIKArrowViewController
@property (nonatomic, copy) NSString *price;
@end
