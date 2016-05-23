//
//  ZIKMySupplyDetailViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyDetailViewController.h"
#import "SupplyDetialMode.h"
#import "SellBanderTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "MySupplyOtherInfoTableViewCell.h"
#import "HotSellModel.h"
#import "ZIKSupplyPublishVC.h"
#import "BigImageViewShowView.h"

//新增
#import "ZIKMySupplyDetailBottomShareTableViewCell.h"//底部分享按钮视图
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#define BOTTOM_SHARE_CELL_HEIGHT 65
//新增end
@interface ZIKMySupplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SellBanderDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) NSString             *uid;
@property (nonatomic, strong) SupplyDetialMode     *model;
@property (nonatomic, strong) UITableView          *tableView;
@property (nonatomic, strong) NSArray              *nurseryDateArray;
@property (nonatomic, strong) HotSellModel         *hotSellModel;
@property (nonatomic, strong) BigImageViewShowView *bigImageVShowV;

//新增
@property (nonatomic,strong ) NSMutableArray *miaomuzhiAry;
@property (nonatomic        ) BOOL           isShow;
@property (nonatomic,strong ) NSArray        *specAry;

@property (nonatomic, strong) NSString       *shareText;
@property (nonatomic, strong) NSString       *shareTitle;
@property (nonatomic, strong) UIImage        *shareImage;
@property (nonatomic, strong) NSString       *shareUrl;
//新增end

@end

@implementation ZIKMySupplyDetailViewController
{
    ZIKMySupplyDetailBottomShareTableViewCell *shareCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
    [self initData];
    [self initUI];
}

- (void)configNav {
    self.vcTitle = @"供应详情";
    self.rightBarBtnTitleString = @"编辑";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        ZIKSupplyPublishVC *zikSupplyPVC = [[ZIKSupplyPublishVC alloc] initWithModel:weakSelf.model];
        [weakSelf.navigationController pushViewController:zikSupplyPVC animated:YES];
    };
}

-(id)initMySupplyDetialWithUid:(ZIKSupplyModel *)ZIKSupplyModel{
    self = [super init];
    if (self) {
        self.uid = ZIKSupplyModel.uid;
        self.hotSellModel =[HotSellModel new];
        self.hotSellModel.area=ZIKSupplyModel.area;
        self.hotSellModel.title=ZIKSupplyModel.title;
        [HTTPCLIENT getMySupplyDetailInfoWithAccessToken:nil accessId:nil clientId:nil clientSecret:nil deviceId:nil uid:ZIKSupplyModel.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic = [responseObject objectForKey:@"result"];
                SupplyDetialMode *model = [SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                model.supplybuyName = APPDELEGATE.userModel.name;
                model.phone = APPDELEGATE.userModel.phone;
                self.model = model;
                if (model.state==1||model.state==3) {
                    shareCell.hidden=YES;
                    CGRect frame=self.tableView.frame;
                    frame.size.height+=54;
                    self.tableView.frame=frame;
                    
                }else
                {
                    shareCell.hidden=NO;
                }
                /*新增*/
                self.specAry = model.spec;
                for (int i=0; i<model.spec.count; i++) {
                    NSDictionary *dic = model.spec[i];
                    NSArray *aryyyyy = [dic objectForKey:@"value"];
                    if (![[aryyyyy firstObject] isEqualToString:@"不限"]) {
                        [_miaomuzhiAry addObject:dic];
                    }
                }
                /*新增end*/


                BigImageViewShowView *bigImageVShowV = [[BigImageViewShowView  alloc]initWithImageAry:model.images];
                self.bigImageVShowV = bigImageVShowV;
                [self.view addSubview:bigImageVShowV];
                self.nurseryDateArray = dic[@"nurseryNames"];
                [self.tableView reloadData];
            }

        } failure:^(NSError *error) {

        }];
    }
    return self;
    
}

- (void)initData {
    self.isShow = NO;
    _miaomuzhiAry = [[NSMutableArray alloc] init];
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-BOTTOM_SHARE_CELL_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate   = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    shareCell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyDetailBottomShareTableViewCell" owner:self options:nil] lastObject];
    shareCell.frame = CGRectMake(0, Height-BOTTOM_SHARE_CELL_HEIGHT, Width, BOTTOM_SHARE_CELL_HEIGHT);
    [shareCell.shareBtn addTarget:self action:@selector(requestShareData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareCell];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 330;
    }
    if (indexPath.section==1) {
        //return self.model.spec.count*30+40;//二期删除掉
        //二期新增
        if (self.specAry) {
            if (_isShow) {
                return self.specAry.count*30+40+40;
            }else{
                return _miaomuzhiAry.count*30+40+40;
            }

        }
        //二期新增end

    }
    if (indexPath.section==2) {
        if (self.nurseryDateArray.count==0) {
            return 130;
        }else{
        return self.nurseryDateArray.count*30+100;
        }
    }
    if (indexPath.section==3) {
        NSString *labelText=self.model.descriptions;

        if (labelText.length==0) {
            labelText = @"暂无";
        }
        return [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
    }
    if (indexPath.section==4) {
        return 100;
    }
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    if(section==4)
    {
        return 50;
    }else
    {
        return 30;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
//    if (section == 1) {
//        UILabel *hintLabel = [[UILabel alloc] init];
//    }
    if (section==4) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.25, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-35, 0, 70, 50)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:BGColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"猜你喜欢"];
        [view addSubview:titleLab];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [view setBackgroundColor:BGColor];
    UIImageView *linImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 2.3, 16)];
    [linImag setBackgroundColor:NavColor];
    [view addSubview:linImag];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    [messageLab setFont:[UIFont systemFontOfSize:13]];
    [messageLab setTextColor:detialLabColor];
    [view addSubview:messageLab];

    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(Width-180, 5, 170, 20);
    hintLabel.textColor = detialLabColor;
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:hintLabel];

    if (section==1) {
        messageLab.text=@"苗木信息";
        hintLabel.text = @"供应信息可分享到微信、QQ";
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"产品描述";
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        if (indexPath.section==0) {
            SellBanderTableViewCell *cell = [[SellBanderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 330) andModel:self.model andHotSellModel:self.hotSellModel];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.model.spec.count*30+40) andName:self.model.productName];
//            cell.ary=self.model.spec;//二期删除
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //二期新增
            [cell.showBtn addTarget:self action:@selector(showOtherMessageAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.showBtn.selected = self.isShow;
            if (self.specAry) {
                if (_isShow) {
                    cell.ary = self.specAry;
                }else{
                    cell.ary = self.miaomuzhiAry;
                }
            }
            //二期新增end
            return cell;

        }
        if(indexPath.section==2)
        {
            MySupplyOtherInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[MySupplyOtherInfoTableViewCell IDStr]];
            if (!cell) {
                cell = [[MySupplyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30*4+10)];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
            cell.model=self.model;
            cell.nuseryAry=self.nurseryDateArray;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }

    if(indexPath.section==3)
    {

        NSString *labelText=self.model.descriptions;
        if (labelText.length==0) {
            labelText = @"暂无";
        }
        CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
        //NSLog(@"%f",height);
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{

    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

-(void)showBigImageWtihIndex:(NSInteger)index
{
    if (self.bigImageVShowV) {
        [self.bigImageVShowV showWithIndex:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//以下方法为二期新增
-(void)showOtherMessageAction:(UIButton *)sender
{
    self.isShow = !self.isShow;
    //一个section刷新
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 我的供应详情-分享供应
- (void)requestShareData {
    ShowActionV();
    [HTTPCLIENT supplyShareWithUid:self.uid Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *shareDic = responseObject[@"result"];
        self.shareText   = shareDic[@"text"];
        self.shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"img"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        self.shareImage  = [[UIImage alloc] initWithData:data];
        self.shareUrl    = shareDic[@"url"];
        RemoveActionV();
        [self umengShare];

    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}

#pragma mark - 友盟分享
- (void)umengShare {
//    [self requestShareData];
//    return;
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
    //NSString *urlString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];

    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;

    //如果是朋友圈，则替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;

    [UMSocialData defaultData].extConfig.qqData.url    = self.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    //设置微信好友title方法为
    //NSString *titleString = @"苗信通-苗木买卖神器";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;

    //设置微信朋友圈title方法替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;

    //QQ设置title方法为

    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;

    //Qzone设置title方法将平台参数名替换即可

    [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;

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
        ShowActionV();
        [HTTPCLIENT supplybuyrRefreshWithUid:self.uid Success:^(id responseObject) {
            RemoveActionV();
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"本条信息已刷新"];

        } failure:^(NSError *error) {
            RemoveActionV();
        }];
    }
    else {
        CLog(@"%@",response);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}

@end
