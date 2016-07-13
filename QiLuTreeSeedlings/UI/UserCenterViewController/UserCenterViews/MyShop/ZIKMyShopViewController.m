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

#import "HttpClient.h"
@interface ZIKMyShopViewController ()<UMSocialUIDelegate>
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSString  *urlString = [NSString stringWithFormat:@"http://115.28.228.147:999?memberUid=%@&appMemberUid=%@&title=1",_memberUid,APPDELEGATE.userModel.access_id];
    //http://101.200.77.145:9000
//    NSString  *urlString = [NSString stringWithFormat:@"http://101.200.77.145:9000?memberUid=%@&appMemberUid=%@&title=1",_memberUid,APPDELEGATE.userModel.access_id];

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
