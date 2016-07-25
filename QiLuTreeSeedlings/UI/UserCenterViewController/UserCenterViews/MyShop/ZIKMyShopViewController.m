//
//  ZIKMyShopViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyShopViewController.h"
#import "UIWebView+AFNetworking.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "HttpClient.h"

static NSString *flag = @"";
@interface ZIKMyShopViewController ()<UMSocialUIDelegate,UIWebViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *shopWebView;
@property (weak, nonatomic) IBOutlet UILabel   *titleLable;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@end

@implementation ZIKMyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_type == 0) {
        self.titleLable.text = @"我的店铺";
    } else {
        self.titleLable.text = @"店铺";
    }
    self.shopWebView.scalesPageToFit =YES;
    self.shopWebView.delegate = self;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    NSString  *urlString = [NSString stringWithFormat:@"http://115.28.228.147:999?memberUid=%@&appMemberUid=%@&title=1",_memberUid,APPDELEGATE.userModel.access_id];
    //http://101.200.77.145:9000
    NSString  *urlString = [NSString stringWithFormat:@"http://dianpu.qlhm.cn?memberUid=%@&appMemberUid=%@&title=1",_memberUid,APPDELEGATE.userModel.access_id];//http://dianpu.qlhm.cn正式的

    //NSString *baidu = @"https://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.shopWebView loadRequest:request];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [ToastView showTopToast:@"正在加载"];
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
   [HTTPCLIENT shopShareWithMemberUid:_memberUid Success:^(id responseObject) {
       if ([responseObject[@"success"] integerValue] == 0) {
           //RemoveActionV();
           [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
           return ;
       }
       NSDictionary *shareDic = responseObject[@"result"];
       self.shareText   = shareDic[@"text"];
       self.shareTitle  = shareDic[@"title"];
       NSString *urlStr = shareDic[@"img"];
       NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
       self.shareImage  = [[UIImage alloc] initWithData:data];
       self.shareUrl    = shareDic[@"url"];
       //RemoveActionV();
       [self umengShare];

   } failure:^(NSError *error) {
       ;
   }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType  {
//    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",requestString);

//    NSString *url = request.URL.absoluteString;
//    NSLog(@"打印请求的URL-->%@", url);
//    NSRange range = [url rangeOfString:@"tel:"];
//    NSUInteger location = range.location;
//    flag = @"";
//    if (location != NSNotFound) {
//        flag = @"wu";
//        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",[url substringFromIndex:4]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    }
//    NSRange smsrange = [url rangeOfString:@"sms:"];
//    NSUInteger smslocation = smsrange.location;
//    if (smslocation != NSNotFound) {
//        flag = @"wu";
//        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"sms://%@",[url substringFromIndex:4]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
////        　[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://%@",[url substringFromIndex:4]]];
//        //[self showMessage:[NSArray arrayWithObjects:[url substringFromIndex:4], nil]];
////        [self showMessageView:[NSArray arrayWithObjects:[url substringFromIndex:4], nil] title:@"苗木供应" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的信息很感兴趣。h"]];
//    }
    return YES;
}

- (void)showMessage:(NSArray *)message {
    NSLog(@"%@",self);
    [self showMessageView:message title:@"苗木供应" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的信息很感兴趣。"]];

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [ToastView showToast:@"消息发送成功" withOriginY:250 withSuperView:self.view];
        }

            break;
        case MessageComposeResultFailed:
            //信息传送失败
        {
            [ToastView showToast:@"消息发送失败" withOriginY:250 withSuperView:self.view];
        }

            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
        {
            [ToastView showToast:@"取消发送" withOriginY:250 withSuperView:self.view];
        }

            break;
        default:
            break;
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];

}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;

        // You can specify one or more preconfigured recipients.  The user has
        // the option to remove or add recipients from the message composer view
        // controller.
        picker.recipients = phones;

        // You can specify the initial message text that will appear in the message
        // composer view controller.
        picker.body = body;

//        [self.navigationController pushViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:NULL];
        //        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        //        controller.recipients = phones;
        //        controller.navigationBar.tintColor = [UIColor redColor];
        //        controller.body = body;
        //        controller.messageComposeDelegate = self;
        //        [self presentViewController:controller animated:YES completion:nil];
//        [[[[picker viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//- (void)phoneCall {
////    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.memberPhone];
////    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    ShowActionV();

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    RemoveActionV();

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if ([flag isEqualToString:@"wu"]) {
        return;
    }
    [ToastView showTopToast:@"加载失败"];
    RemoveActionV();

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)umengShare {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];

    NSString *urlString = self.shareUrl;


    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;

    //如果是朋友圈，则替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;

    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
    //    NSString *titleString = @"苗信通-苗木买卖神器";
    NSString *titleString = self.shareTitle;

    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;

    //设置微信朋友圈title方法替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;

    //QQ设置title方法为

    [UMSocialData defaultData].extConfig.qqData.title = titleString;

    //Qzone设置title方法将平台参数名替换即可

    [UMSocialData defaultData].extConfig.qzoneData.title = titleString;

}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    //NSLog(@"finish share with response is %@",response);
}

@end
