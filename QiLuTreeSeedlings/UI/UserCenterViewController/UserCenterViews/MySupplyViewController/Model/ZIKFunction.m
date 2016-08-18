//
//  ZIKFunction.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKFunction.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIAlertView+Blocks.h"
#import "WXApi.h"
#import "HttpDefines.h"
#import "UIDefines.h"
/*********支付宝相关*********/
#define kwshZhiFuBaoZhangHao @"2088121068006558"
#define kzhifubaoSeller @"2549113992@qq.com"
#define kzhifubaoMiYao @"MIICXAIBAAKBgQDfGYkTCYlYF7+8nWlDYFP8vg7FQ6e6GfWQzVx/6zuQGKCStUaUF2XDz3BwzcBcpSHRnAOdyancDpv8/0TsfxdTFQCmVHbMUso6urUzkAXpOT8X0PcDPOBDPIeCefNNNeuEh9e6JcQNbKEGFRc27QwUEBSgSEE6ivD1iFpCiO9jSQIDAQABAoGBANI8P/3emLyY9KgLNiy1069ycnzV+nLXD5+6xhYNV/28F2Toym+3dMCG9JB4c3NacXoTKR1B8n1ajwhkjVDHmvN/LUc5WUW9p66khub0auu7JsHxALlE8AqmrV93VSCm8ijsKzUzKeO5vzJqJpfLGli/CSgFHMZuqbhi+rN84hxhAkEA+JkqF9VE8ZssBmYbNvLJ4FvzF6Jt8zOBqvvkCidp07KQ8JcD3uCKvbCEvwjRHMa5/0lRihkKnJTer4Gci+7lZQJBAOW+BOKi6KfWUuRnUmZ7F4/s5ZGImrxqynpOpoiVFI3LJ1i50jbPHuJ+aWeHPTmTRi3vd06F66/IcNQTJMikKhUCQBT7+M2iNvud+Y1guRNeUyQZHt/z2gwZYOyp7onc4dX40Ls+RBlgItX4PHxTpjMjozelXLinfHnTJyjxa+Fz/PECQDSJlr5pOMEg7wXSZvKOlZ3RM9JrJc+OsEz17XlwdinS2mWc4OitxsdO1zXYpHSlLDhW+baYQ4SIVtz4n8HOYN0CQAcsC5oLfqqVVio5DxpE3ZW0WmGpYAD/17CgHgdpUj09rX6efosuZ6INupV5ARsworkO9qGz+vN+VULIpN+WoZc="
/*********end支付宝相关end*********/
//#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)

@implementation ZIKFunction


+ (void)zhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId supplyBuyUid:(NSString *)supplyBuyUid type:(NSString *)type
{


    NSString *partner    = kwshZhiFuBaoZhangHao;
    NSString *seller     = kzhifubaoSeller;
    NSString *privateKey = kzhifubaoMiYao;

    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription = title; //商品描述
    order.amount = price; //商品价格

    // NSMutableDictionary *infor = [[XtomManager sharedManager] myinitInfor];
    //NSString * updateURL = [infor objectForKey:@"mall_server_ip"];
//#warning 注释
    NSString * updateURL = AFBaseURLString;
    // NSString * updateURL = RequestURL;
    updateURL = [updateURL stringByAppendingString:@"apimember/pay/alipay/notify"];

    if ([type isEqualToString:@"2"]) {
    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&recordUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    } else {
   order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    }
//    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=\"%@\"&type=\"%@\"",updateURL,orderId,supplyBuyUid,type]; //回调URL


    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"miaoxintong";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //NSLog(@"%@",privateKey);
    //orderSpec = [orderSpec stringByAppendingString:[NSString stringWithFormat:@"?access_id=\"%@\"",orderId]];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
       // NSLog(@"str=%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                //                [kApp telSevicePaySuccess:self.oderID];
                //                UIAlertView *seccuss = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //                seccuss.tag = 166;
                //                [seccuss show];
//                if (APPDELEGATE.isFromSingleVoucherCenter) {
//                        
//                } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaiGouSinglePaySuccessNotification" object:nil];

                if (!APPDELEGATE.isFromSingleVoucherCenter) {
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                }

                //}

                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付成功!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

                    //[controller.navigationController popToRootViewControllerAnimated:YES];


                }] otherButtonItems:nil, nil] show];


            }
            else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"4000"]) {
                //NSLog(@"订单交易失败");
               // NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

                    //[controller.navigationController popToRootViewControllerAnimated:YES];

                }] otherButtonItems:nil, nil] show];
            } else {
                NSLog(@"%@",resultDic);
                NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

                    //[controller.navigationController popToRootViewControllerAnimated:YES];

                }] otherButtonItems:nil, nil] show];

            }
        }];


    }

}

//微信支付
+ (NSString *)weixinPayWithOrderID:(NSString *)orderID{
    //XtomManager *manager = [XtomManager sharedManager];
    //NSString *urlString = [NSString stringWithFormat:@"%@%@%@",AFBaseURLString,@"apimember/pay/wx/notify/",orderID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",AFBaseURLString,@"apimember/pay/wx/notify/",orderID];

//
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"%@", urlString];
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSString *parmStr = orderID;
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];

    // 创建同步链接
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        dict = [dict objectForKey:@"info"];
        if(dict != nil){
            //            NSMutableString *retcode = [dict objectForKey:@"status"];
            //            if (retcode.intValue == 1){
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
            //日志输出
            return @"";
            //            }else{
            //                return [dict objectForKey:@"retmsg"];
            //            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }

    
}

#pragma mark - 设置TableView空行分割线隐藏
// 设置TableView空行分割线隐藏
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 字符串判空
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr  //字符串判空
{
    if (!parmStr) {
        return YES;
    }
    if ([parmStr isEqual:nil]) {
        return YES;
    }
    if ([parmStr isEqual:@""]) {
        return YES;
    }
    id tempStr=parmStr;
    if (tempStr==[NSNull null]) {
        return YES;
    }
    return NO;
}

#pragma mark - 计算指定时间与当前的时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSInteger temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",(long)temp];
    }

    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",(long)temp];
    }

    else if((temp = temp/24)){

        if (temp/7 < 1) {
            result = [NSString stringWithFormat:@"%ld天前",(long)temp];
        }
        else {
            result = [NSString stringWithFormat:@"%ld周前",(long)temp/7];
        }
    }

//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",(long)temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",(long)temp];
//    }

    return  result;
}

#pragma mark - 时间转字符串
+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

#pragma  mark -  字符串转时间
+(NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}

#pragma mark   ==============产生随机订单号==============
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;

    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(myimage, 0.1);
        }
        else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(myimage, 0.9);
        }
        else if (data.length>200*1024) {//0.25M-0.5M
            data = UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
+ (BOOL)xfunc_isPassword:(NSString*)password
{
    NSString *regex = @"^[a-zA-Z_0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:password];
}
//验证数字和小数点:^[0-9]+([.]{0}|[.]{1}[0-9]+)$
+ (BOOL)xfunc_isAmount:(NSString*)amount
{
    NSString *regex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:amount];
}
#pragma mark - 获取字符串的CGRect
//获取字符串的CGRect
+(CGRect)getCGRectWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{

    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect;
}

@end
