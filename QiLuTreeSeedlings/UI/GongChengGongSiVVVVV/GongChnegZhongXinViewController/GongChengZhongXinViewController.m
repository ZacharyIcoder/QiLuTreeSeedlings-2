//
//  GongChengZhongXinViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GongChengZhongXinViewController.h"
#import "YLDGongChengZhongXinBigCell.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "yYLDCompanyMessageCell.h"
#import "YLDGCZXzizhiCell.h"
#import "UIDefines.h"
#import "ZIKMyHonorViewController.h"
#import "YLDGongChengAnLiViewController.h"
#import "UIDefines.h"
#import "YLDGCZXInfoViewController.h"
#import "UIImageView+AFNetworking.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享
@interface GongChengZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
@property (nonatomic,weak)UITableView *talbeView;
@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@end

@implementation GongChengZhongXinViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *talbeView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    talbeView.delegate=self;
    talbeView.dataSource=self;
    talbeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.talbeView=talbeView;
    [self.view addSubview:talbeView];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 200;
        }
        if (indexPath.row==1) {
            return 120;
        }
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            YLDGongChengZhongXinBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongChengZhongXinBigCell"];
            if (!cell) {
                cell=[YLDGongChengZhongXinBigCell yldGongChengZhongXinBigCell];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell.imageBtn addTarget:self action:@selector(gczzMessageAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.userImagV setImageWithURL:[NSURL URLWithString:APPDELEGATE.GCGSModel.attachment] placeholderImage:[UIImage imageNamed:@"UserImage"]];
            
            cell.model=APPDELEGATE.GCGSModel;
            return cell;
            
        }
        if (indexPath.row==1) {
            yYLDCompanyMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDCompanyMessageCell"];
            if (!cell) {
                cell=[yYLDCompanyMessageCell yyldCompanyMessageCell];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.model=APPDELEGATE.GCGSModel;
            return cell;
            
        }
    }
    if(indexPath.section==1)
    {
        YLDGCZXzizhiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXzizhiCell"];
        if (!cell) {
            cell=[YLDGCZXzizhiCell yldGCZXzizhiCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==0) {
            [cell setMessageWithImageName:@"GCZXgongsizizhi.png" andTitle:@"公司资质"];
        }
        if (indexPath.row==1) {
            [cell setMessageWithImageName:@"GCZXgongsianli.png" andTitle:@"公司案例"];
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)gczzMessageAction
{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
    YLDGCZXInfoViewController *ViewController=[[YLDGCZXInfoViewController alloc]init];
    [self.navigationController pushViewController:ViewController animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
        ZIKMyHonorViewController *norViewController=[[ZIKMyHonorViewController alloc] init];
        norViewController.type = TypeQualification;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        [self.navigationController pushViewController:norViewController animated:YES];
        }
        if (indexPath.row==1) {
            [ToastView showTopToast:@"暂无数据"];
            return;
            YLDGongChengAnLiViewController *gChengController=[[YLDGongChengAnLiViewController alloc] init];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
            [self.navigationController pushViewController:gChengController animated:YES];
        }
    }
}

-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==3)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.talbeView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)shareBtnAction{
    ShowActionV();
    [HTTPCLIENT GCZXShareSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            RemoveActionV();
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *shareDic = [responseObject[@"result"] objectForKey:@"share"];
        self.shareText   = shareDic[@"text"];
        self.shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"pic"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        self.shareImage  = [[UIImage alloc] initWithData:data];
        self.shareUrl    = shareDic[@"url"];
        RemoveActionV();
        [self umengShare];
        
    } failure:^(NSError *error) {
        RemoveActionV();
    }];

}
- (void)umengShare {
    
    //    [UMSocialSnsService presentSnsIconSheetView:self
    //                                         //appKey:@"569c3c37e0f55a8e3b001658"
    //                                         appKey:@"56fde8aae0f55a1cd300047c"
    //                                      shareText:@"定制精准信息，轻松买卖苗木，没有效果不花钱，下载注册即可赠送积分。"
    //                                     shareImage:[UIImage imageNamed:@"logV@2x.png"]
    //                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
    //                                       delegate:self];
    [UMSocialSnsService presentSnsIconSheetView:self
     //appKey:@"569c3c37e0f55a8e3b001658"
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    
    //[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"sharTestQQ分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //            NSLog(@"分享成功！");
    //        }
    //    }];
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    //NSString *urlString = @"https://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8";
    // NSString *urlString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
