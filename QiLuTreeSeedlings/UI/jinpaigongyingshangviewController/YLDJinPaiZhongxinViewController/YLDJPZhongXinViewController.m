//
//  YLDJPZhongXinViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPZhongXinViewController.h"
#import "YLDJPGYSInfoViewController.h"
#import "YLDJPGYSDBigCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YLDJPGYSJJCell.h"
#import "YLDJPGYSInfoLabCell.h"
#import "YLDGCZXzizhiCell.h"
#import "ZIKMyHonorViewController.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享
@interface YLDJPZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSDictionary *dic;
@property (nonatomic) BOOL isShow;
@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@end

@implementation YLDJPZhongXinViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getdata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, kWidth, kHeight-50) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone; 
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(void)getdata
{
    [HTTPCLIENT goldSupplierInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
            self.dic=[responseObject objectForKey:@"result"];
            APPDELEGATE.userModel.brief=self.dic[@"brief"];
            [self.tableView reloadData];
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 200;
    }
    if (indexPath.row==1) {
        if (_isShow) {
            NSString *str=self.dic[@"brief"];
            NSString *jianjieStr=@"简介：";
            if (str.length>0) {
                jianjieStr = [NSString stringWithFormat:@"简介：%@",str];
            }
            CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
            if (hightzz>40) {
                return hightzz+40;
                
            }else{
                return 80;
            }
        }else{
            return 80;
        }

    }
    if (indexPath.row==2) {
        NSString *companyName=self.dic[@"companyName"];
        if (companyName.length>0) {
            CGFloat hiss=[self getHeightWithContent:companyName width:kWidth-124 font:15];
            if (hiss>18) {
                return 160;
            }
        }
        
        return 140;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDJPGYSDBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSDBigCell"];
        
        if (!cell) {
            cell=[YLDJPGYSDBigCell YLDJPGYSDBigCell];
            [cell.touxiangBtn addTarget:self action:@selector(touxiangBtnAcion) forControlEvents:UIControlEventTouchUpInside];
            [cell.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
            cell.shareBtn.hidden=NO;
            [cell.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.myDic=self.dic;
        return cell;
    }
    if (indexPath.row==1) {
        YLDJPGYSJJCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSJJCell"];
        if (!cell) {
            cell=[YLDJPGYSJJCell yldJPGYSJJCell];
            [cell.chakanBtn addTarget:self action:@selector(chakanBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        NSString *str=self.dic[@"brief"];
        NSString *jianjieStr=@"简介：";
        if (str.length>0) {
            jianjieStr = [NSString stringWithFormat:@"简介：%@",str];
        }
        CGRect frame=cell.frame;
        CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
        if (hightzz<40) {
            cell.chakanBtn.hidden=YES;
        }
        if (_isShow) {
            CGFloat hightzz=[self getHeightWithContent:jianjieStr width:kWidth-24 font:15];
            if (hightzz>40) {
                frame.size.height=hightzz+40;
                cell.frame=frame;
                cell.chakanBtn.hidden=NO;
                cell.chakanBtn.selected=YES;
            }
        }else{
            frame.size.height=80;
            cell.frame=frame;
            cell.chakanBtn.selected=NO;
        }
        
        cell.jianjieStr=jianjieStr;
        return cell;
    }
    if (indexPath.row==2) {
        YLDJPGYSInfoLabCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSInfoLabCell"];
        if (!cell) {
            cell=[YLDJPGYSInfoLabCell yldJPGYSInfoLabCell];
        }
        NSString *companyName=self.dic[@"companyName"];
        if (companyName.length>0) {
            CGFloat hiss=[self getHeightWithContent:companyName width:kWidth-124 font:15];
            CGRect frame =cell.frame;
            if (hiss>18) {
                frame.size.height=160;
            }else{
                frame.size.height=140;
            }
            cell.frame=frame;
        }
        
        
        
        cell.dic=self.dic;
        return cell;
    }
   
    if (indexPath.row==3) {
        YLDGCZXzizhiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXzizhiCell"];
        if (!cell) {
            cell=[YLDGCZXzizhiCell yldGCZXzizhiCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setMessageWithImageName:@"GCZXgongsizizhi.png" andTitle:@"金牌资质"];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)touxiangBtnAcion
{
    YLDJPGYSInfoViewController *vvcc=[[YLDJPGYSInfoViewController alloc]init];
    [self.navigationController pushViewController:vvcc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==3)
    {
        ZIKMyHonorViewController *zikMyHonorVC=[[ZIKMyHonorViewController alloc]init];
        
        zikMyHonorVC.type=TypeMyJPGYSHonorOther;
        zikMyHonorVC.memberUid=APPDELEGATE.userModel.access_id;
        zikMyHonorVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:zikMyHonorVC animated:YES];
    }
}
-(void)chakanBtnAction
{
    _isShow=!_isShow;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)backBtnAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
-(void)shareBtnAction{
    ShowActionV();
    [HTTPCLIENT goldsupplierShareSuccess:^(id responseObject) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
