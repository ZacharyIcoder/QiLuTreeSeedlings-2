//
//  SellDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellDetialViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "SupplyDetialMode.h"
#import "HotSellModel.h"
#import "SellBanderTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "SellQiyeInfoTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BigImageViewShowView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import "ZIKMyShopViewController.h"
#import "ZIKHeZuoMiaoQiKeFuViewController.h"
@interface SellDetialViewController ()<UITableViewDataSource,UITableViewDelegate,SellBanderDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong)SupplyDetialMode *model;
@property (nonatomic,strong)NSArray *guseLikeAry;
@property (nonatomic,strong)HotSellModel *hotModel;
@property (nonatomic,strong)BigImageViewShowView *bigImageVShowV;

//新增
//@property (nonatomic,strong ) NSMutableArray *miaomuzhiAry;
//@property (nonatomic        ) BOOL           isShow;
//@property (nonatomic,strong ) NSArray        *specAry;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url


@property (nonatomic, strong) NSString *memberUid;

@end

@implementation SellDetialViewController
-(id)initWithUid:(HotSellModel *)model
{
    self.hotModel=model;
    self=[super init];
    if (self) {
        
        [HTTPCLIENT sellDetailWithUid:model.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                model.goldsupplier=[dic[@"goldsupplier"] integerValue];
                if (model.uid.length<=0) {
                    [ToastView showTopToast:@"请刷新列表后重新进入该供应"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                self.memberUid = dic[@"memberUid"];
                self.model=model;
                  BigImageViewShowView *bigImageVShowV=[[BigImageViewShowView  alloc]initWithImageAry:model.images];
                self.hotModel.title=model.title;
                self.bigImageVShowV=bigImageVShowV;
                [self.view addSubview:bigImageVShowV];

                if(model.collect)
                {
                    self.collectionBtn.selected=YES;
                }
                self.guseLikeAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"list"]];
              
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
}
    return self;
   
}

//- (instancetype)initWithHeZuoMiaoQiUid:(HotSellModel *)model {
////
//}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.isShow = NO;
//    _miaomuzhiAry = [[NSMutableArray alloc] init];

    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-50) style:UITableViewStyleGrouped];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    if (self.type == 0) {
        self.tableView.frame = CGRectMake(0, 44, kWidth, kHeight-50-44);
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*2.5/5, 1)];
        topLineView.backgroundColor = kLineColor;
        [self.view addSubview:topLineView];

        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [self.view addSubview:shopBtn];

        UIButton *kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*3/5, 50)];
        [kefuBtn setBackgroundColor:[UIColor whiteColor]];
        [kefuBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [kefuBtn setTitle:@"专属客服" forState:UIControlStateNormal];
        [kefuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        kefuBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [kefuBtn setImage:[UIImage imageNamed:@"形状-6"] forState:UIControlStateNormal];
//        kefuBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 30);
        [kefuBtn addTarget:self action:@selector(kefuBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:kefuBtn];


        UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*4/5,kHeight-50, kWidth*1/5, 50)];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shareBtn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:yellowButtonColor];
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];

        return;
    }

    if (!APPDELEGATE.isNeedLogin) {

        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*2/5, 1)];
        topLineView.backgroundColor = kLineColor;
        [self.view addSubview:topLineView];

        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [self.view addSubview:shopBtn];

//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, 2, 50)];
//        lineView.backgroundColor = kLineColor;
//        [self.view addSubview:lineView];


        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, kHeight-50+1, kWidth*2/5, 50-1)];
        [messageBtn setBackgroundColor:[UIColor whiteColor]];
        [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [self.view addSubview:messageBtn];
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/5, kHeight-50, kWidth*2/5, 50)];
        [phoneBtn   .titleLabel setFont:[UIFont systemFontOfSize:15]];
        [phoneBtn setTitle:@"联系供应商" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        //[messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
        [self.view addSubview:phoneBtn];

    } else {

        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*2.5/5, 1)];
        topLineView.backgroundColor = kLineColor;
        [self.view addSubview:topLineView];

        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [self.view addSubview:shopBtn];

//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, 2, 50)];
//        lineView.backgroundColor = kLineColor;
//        [self.view addSubview:lineView];


        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, kHeight-50+1, kWidth*1.5/5, 50-1)];
        [messageBtn setBackgroundColor:[UIColor whiteColor]];
        [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [self.view addSubview:messageBtn];
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*2.5/5, kHeight-50, kWidth*1.5/5, 50)];
        [phoneBtn   .titleLabel setFont:[UIFont systemFontOfSize:15]];
        [phoneBtn setTitle:@"联系供应商" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.view.frame.size.width == 320) {
            phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
            phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        } else {
            phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        }
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        //[messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
        [self.view addSubview:phoneBtn];

        UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*4/5,kHeight-50, kWidth*1/5, 50)];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shareBtn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        [shareBtn setBackgroundColor:yellowButtonColor];
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];

    }



    //    [APPDELEGATE]
}
- (void)kefuBtnClcik {
    ZIKHeZuoMiaoQiKeFuViewController *kefuVC = [[ZIKHeZuoMiaoQiKeFuViewController alloc] initWithNibName:@"ZIKHeZuoMiaoQiKeFuViewController" bundle:nil];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
- (void)shopBtnAction {
    if (_memberUid<=0) {
        [ToastView showTopToast:@"该店铺歇业中"];
        return;
    }
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
//    self.memberUid = dic[@"memberUid"];
    shopVC.memberUid = _memberUid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];

}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.memberPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark -- 短信留言
-(void)meaageAction
{
    [self showMessageView:[NSArray arrayWithObjects:self.model.memberPhone, nil] title:@"苗木供应" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的供应信息:%@ 很感兴趣",self.model.title]];
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

        [self presentViewController:picker animated:YES completion:NULL];
//        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = phones;
//        controller.navigationBar.tintColor = [UIColor redColor];
//        controller.body = body;
//        controller.messageComposeDelegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
        [[[[picker viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

            return 365;

    }
    if (indexPath.section==1) {
        if (self.model.spec.count>0) {
             return self.model.spec.count*30+35;
        }
        else return 44;
//        //二期新增
//        if (self.specAry) {
//            if (_isShow) {
//                return self.specAry.count*30+40+40;
//            }else{
//                return _miaomuzhiAry.count*30+40+40;
//            }
//
//        }
//        //二期新增end

       
    }
    if (indexPath.section==2) {
        return 130;
    }
    if (indexPath.section==3) {
        NSString *labelText=self.model.descriptions;

        if (labelText.length==0) {
            labelText=@"暂无";
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
    if (section==4) {
        return self.guseLikeAry.count;
    }else
    {
    return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
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
    if (section==1) {
        messageLab.text=@"苗木信息";
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
//            CGFloat height;
//            if (self.model.goldsupplier==0||self.model.goldsupplier==10) {
//                height=320;
//            }else{
//                height=350;
//            }
            SellBanderTableViewCell *cell=[[SellBanderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 365) andModel:self.model andHotSellModel:self.hotModel];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.model.spec.count*30+35) andName:self.model.productName];
            cell.ary=self.model.spec;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.showBtn.hidden = YES;

            return cell;
        }
        if(indexPath.section==2)
        {
            SellQiyeInfoTableViewCell *cell = [[SellQiyeInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30*4+10)];
            cell.model = self.model;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if(indexPath.section==3)
    {
        
        NSString *labelText=self.model.descriptions;
        if (labelText.length==0) {
            labelText=@"暂无";
        }
        
        CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
        //NSLog(@"%f",height);
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setTextColor:titleLabColor];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.section==4) {
        SellSearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SellSearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[SellSearchTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.hotSellModel=self.guseLikeAry[indexPath.row];
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}

////以下方法为二期新增
//-(void)showOtherMessageAction:(UIButton *)sender
//{
//    self.isShow = !self.isShow;
//    //一个section刷新
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}

//图片点击效果
-(void)showBigImageWtihIndex:(NSInteger)index
{
    if (self.bigImageVShowV) {
      [self.bigImageVShowV showWithIndex:index];
    }
    
}

//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"供应详情"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
        [view addSubview:titleLab];
    UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
    self.collectionBtn = collectionBtn;
    [collectionBtn setImage:[UIImage imageNamed:@"collectionN"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"collectionT"] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectionBtn];
    return view;
}
-(void)collectionBtn:(UIButton *)sender
{
    if(![APPDELEGATE isNeedLogin])
    {
        [ToastView showTopToast:@"请先登录"];
        return;
    }
        if (sender.selected==NO) {
            [HTTPCLIENT collectSupplyWithSupplyNuresyid:self.model.uid Success:^(id responseObject) {
                
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"收藏成功"];
                    sender.selected=YES;
                    [HTTPCLIENT sellDetailWithUid:self.hotModel.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
                        //NSLog(@"供应详情：%@",responseObject);
                        if ([[responseObject objectForKey:@"success"] integerValue]) {
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                            self.model=model;
                            
                        }
                    } failure:^(NSError *error) {
                        
                    }];

                    return ;
                }
            } failure:^(NSError *error) {
                return ;
            }];
        }
    if (sender.selected) {
        
//        NSArray *ary=[NSArray arrayWithObject:self.model.collectUid];
        NSMutableString *keystr=[NSMutableString new];
        [keystr appendFormat:@"%@",self.model.collectUid];
        [HTTPCLIENT deletesenderCollectWithIds:keystr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
                }
        } failure:^(NSError *error) {
            
        }];
    }
    //NSLog(@"collectionBtnAction");
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)jsonAnswerStrWithAry:(NSArray *)ary
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:&parseError];
    
   NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
       HotSellModel  *model=self.guseLikeAry[indexPath.row];
        
        SellDetialViewController *vc=[[SellDetialViewController alloc]initWithUid:model];
        [self.navigationController pushViewController:vc
                                             animated:YES];
//        BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
        //[self.navigationController pushViewController:vc animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)shareBtnClick {
    [self requestShareData];
}

#pragma mark - 热门供应分享
- (void)requestShareData {
    ShowActionV();
    //CLog(@"hotuid:%@,  hotsupplyuid:%@  ,selfmodelsupplyuid:%@",self.hotModel.uid,self.hotModel.supplybuyUid,self.model.supplybuyUid)
    [HTTPCLIENT supplyShareWithUid:self.model.supplybuyUid nurseryUid:self.model.nurseryUid Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
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
