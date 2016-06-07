//
//  BuyDetialInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyDetialInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "BuyUserInfoTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "QIYeMessageTableViewCell.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialModel.h"
#import "buyFabuViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "BuyMessageAlertView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "LoginViewController.h"
#import "ZIKPayViewController.h"

//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

@interface BuyDetialInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *navTitleLab;
@property (nonatomic,strong)UIButton *collectionBtn;
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSArray *specAry;
@property (nonatomic,strong)NSArray *recommendeAry;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic) NSInteger type;
@property (nonatomic,strong)BuyDetialModel *model;
@property (nonatomic) BOOL isPuy;
@property (nonatomic) BOOL isShow;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UIView *BuyMessageView;
@property (nonatomic,strong) UIImageView *biaoqianView;
@property (nonatomic,weak)BuyMessageAlertView *buyAlertView;
@property (nonatomic,strong) NSMutableArray *miaomuzhiAry;
@property (nonatomic,weak) UIImageView *guoqiIamgV;
@property (nonatomic,weak) UIButton *editingBtn;
@property (nonatomic)NSInteger push_;
@property (nonatomic,copy) NSString *memberCustomUid;

//@property (nonatomic, strong) NSString *state;//用于求购中 1:热门求购（热门求购中除去已定制和已购买的）；2：我的求购；3：已定制；4：已购买
@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url

@property (nonatomic, assign) BOOL isFromDingzhi;
@end

@implementation BuyDetialInfoViewController
{
    UIButton *myshareBtn;
}
-(void)dealloc{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.type==2) {
        [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                if (![[responseObject objectForKey:@"success"] integerValue]) {
                                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                [self.navigationController popViewControllerAnimated:YES];
                                    return ;
                                }
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];

                                self.model.uid=self.uid;
                                [self reloadMyView];
                            } failure:^(NSError *error) {
                                
                            }];
        return;
    }
    if (self.isFromDingzhi) {
        return;
    }
    [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                        WithType:[NSString stringWithFormat:@"%ld",_push_] WithmemberCustomUid:_memberCustomUid                             Success:^(id responseObject) {
                            //NSLog(@"%@",responseObject);
                            if (![[responseObject objectForKey:@"success"] integerValue]) {
                                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                               [self.navigationController popViewControllerAnimated:YES];
                            }
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            self.infoDic=dic;
                            self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
                                                       self.model.uid=self.uid;
                            if (self.model.push||self.model.buy) {
                                self.isPuy=YES;
                                _biaoqianView.hidden=NO;
                                if (self.model.push) {
                                    [_biaoqianView setImage:[UIImage imageNamed:@"dibgzhibiaoqian"]];
                                }
                                if (self.model.buy) {
                                    [_biaoqianView setImage:[UIImage imageNamed:@"buybiaoqian"]];
                                }
                            }else
                            {
                                
                                self.isPuy=NO;
                            }
                            if (!self.isPuy) {
                                
                                
                                if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                                     [_BuyMessageView removeFromSuperview];
                                    _BuyMessageView =nil;
                                }else
                                {
                                   // NSLog(@"%@-----%@",self.model.supplybuyUid,APPDELEGATE.userModel.access_id);
                                    if (_BuyMessageView==nil) {
                                        if (self.model.state == 4) {
                                            _BuyMessageView =[self laobanShareViewWithPrice:self.model.buyPrice];
                                        }
                                        else {
                                            _BuyMessageView = [self laobanViewWithPrice:self.model.buyPrice];
                                        }
                                        [_messageView removeFromSuperview];
                                        _messageView = nil;

                                    }
                                }

                            
                            }else{
                                if (_messageView==nil) {
                                    if (self.model.state == 4) {
                                        _messageView = [self lianxiMessageShareView];

                                    }
                                    else {
                                        _messageView = [self lianxiMessageView];
                                    }
                                    [_BuyMessageView removeFromSuperview];
                                    _BuyMessageView = nil;
                                }
                            }
                            [self reloadMyView];
                        } failure:^(NSError *error) {
                            
                        }];
}
-(id)initWithDingzhiModel:(ZIKCustomizedInfoListModel *)model
{
    self=[super init];
    if (self) {
        self.isPuy=NO;
        self.uid=model.uid;
        self.type=1;
        _push_=1;
        self.memberCustomUid=model.memberCustomUid;
        self.isFromDingzhi = YES;
        self.biaoqianView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-50, 64, 50, 50)];
        _biaoqianView.hidden = YES;
        [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:@"1" WithmemberCustomUid:self.memberCustomUid                             Success:^(id responseObject) {
                                if (![[responseObject objectForKey:@"success"] integerValue]) {
                                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                   [self.navigationController popViewControllerAnimated:YES];
                                }
                                //NSLog(@"%@",responseObject);
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
                                self.model.uid=self.uid;
                                if (self.model.push||self.model.buy) {
                                    self.isPuy=YES;
                                    _biaoqianView.hidden=NO;
                                    if (self.model.push) {
                                        [_biaoqianView setImage:[UIImage imageNamed:@"dibgzhibiaoqian"]];
                                    }
                                    if (self.model.buy) {
                                        [_biaoqianView setImage:[UIImage imageNamed:@"buybiaoqian"]];
                                    }
                                }else
                                {
                                    
                                    self.isPuy=NO;
                                }
                                if (!self.isPuy) {
                                    
                                    
                                    if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                                        [_BuyMessageView removeFromSuperview];
                                        _BuyMessageView =nil;
                                    }else
                                    {
                                        // NSLog(@"%@-----%@",self.model.supplybuyUid,APPDELEGATE.userModel.access_id);
                                        if (_BuyMessageView==nil) {
                                            if (self.model.state == 4) {
                                                _BuyMessageView =[self laobanShareViewWithPrice:self.model.buyPrice];
                                            }
                                            else {
                                                _BuyMessageView = [self laobanViewWithPrice:self.model.buyPrice];
                                            }
                                            [_messageView removeFromSuperview];
                                            _messageView = nil;
                                            
                                        }
                                    }
                                    
                                    
                                }else{
                                    if (_messageView==nil) {
                                        if (self.model.state == 4) {
                                            _messageView = [self lianxiMessageShareView];

                                        }
                                        else {
                                            _messageView = [self lianxiMessageView];
                                        }
                                        [_BuyMessageView removeFromSuperview];
                                        _BuyMessageView = nil;
                                    }
                                }
                                [self reloadMyView];
                            } failure:^(NSError *error) {
                                
                            }];

    }
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:_biaoqianView];
    UIImageView  *guoqiIamgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-80, 50, 74, 48.3)];
    [self.tableView addSubview:guoqiIamgV];
    [guoqiIamgV bringSubviewToFront:self.view];
    self.guoqiIamgV=guoqiIamgV;

    return self;
}
-(id)initWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.isPuy=NO;
        self.uid=uid;
        self.type=1;
        self.biaoqianView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-50, 64, 50, 50)];
        self.isFromDingzhi = NO;//不是从定制列表进入的
        _biaoqianView.hidden=YES;
      //  NSLog(@"%@",uid);
        [HTTPCLIENT buyDetailWithUid:uid WithAccessID:APPDELEGATE.userModel.access_id
         WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
             if (![[responseObject objectForKey:@"success"] integerValue]) {
                 [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                 [self.navigationController popViewControllerAnimated:YES];
             }
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            self.infoDic=dic;
             self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
             self.model.uid=uid;
             if (self.model.push||self.model.buy) {
                 self.isPuy=YES;
                 _biaoqianView.hidden=NO;
                 if (self.model.push) {
                     [_biaoqianView setImage:[UIImage imageNamed:@"dibgzhibiaoqian"]];
                 }
                 if (self.model.buy) {
                      [_biaoqianView setImage:[UIImage imageNamed:@"buybiaoqian"]];
                 }
             }else
             {
                 
                 self.isPuy=NO;
             }
             if (!self.isPuy) {
                 if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                     self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64-70);
                     [_BuyMessageView removeFromSuperview];
                     
                     _BuyMessageView =nil;
                     myshareBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 50)];
                     [myshareBtn setBackgroundColor:NavColor];
                     [myshareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
                     [myshareBtn setTitle:@"分享" forState:UIControlStateNormal];
                     [self.view addSubview:myshareBtn];
                 }else
                 {
                     if (_BuyMessageView==nil) {
                         //_BuyMessageView =[self laobanShareViewWithPrice:self.model.buyPrice];
                         if (self.model.state == 4) {
                             _BuyMessageView =[self laobanShareViewWithPrice:self.model.buyPrice];
                         }
                         else {
                             _BuyMessageView = [self laobanViewWithPrice:self.model.buyPrice];
                         }

                         [_messageView removeFromSuperview];
                         _messageView = nil;
                         
                     }
                 }

             }else{
                 //_messageView = [self lianxiMessageShareView];
                 if (self.model.state == 4) {
                     _messageView = [self lianxiMessageShareView];

                 }
                 else {
                     _messageView = [self lianxiMessageView];
                 }

             }

             [self reloadMyView];
        } failure:^(NSError *error) {

        }];
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
         [self.view addSubview:_biaoqianView];
        UIImageView  *guoqiIamgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-80, 50, 73, 48.3)];
        [self.tableView addSubview:guoqiIamgV];
        [guoqiIamgV bringSubviewToFront:self.view];
        self.guoqiIamgV=guoqiIamgV;

    }
    return self;
}
-(id)initMyDetialWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
        self.type=2;
        self.isFromDingzhi = NO;//不是从定制列表进入的

        [HTTPCLIENT buyDetailWithUid:uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                if (![[responseObject objectForKey:@"success"] integerValue]) {
                                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
                                self.model.uid=uid;
                                if (self.model.state==4) {
                                    myshareBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, kHeight-60, kWidth-80, 50)];
                                    [myshareBtn setBackgroundColor:NavColor];
                                    [myshareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                    [myshareBtn setTitle:@"分享" forState:UIControlStateNormal];
                                    [self.view addSubview:myshareBtn];
                                    
                                }

                                [self reloadMyView];
                                self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64-70);
                            } failure:^(NSError *error) {
                                
                            }];
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-70) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        UIImageView  *guoqiIamgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-68, 60, 60, 38.3)];
        [self.tableView addSubview:guoqiIamgV];
        self.guoqiIamgV=guoqiIamgV;
        [self.view addSubview:self.tableView];
        }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView =  [self makeNavView];
    [self.view addSubview:navView];
    self.isShow=NO;
    self.isFromDingzhi = NO;//不是从定制列表进入的
    [self.view setBackgroundColor:BGColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


-(UIView *)lianxiMessageView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/2, 50)];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.7]];
    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
    [view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2,0, kWidth/2, 50)];
    [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:NavColor];
    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];

    [self.view addSubview:view];
    return view;
}

-(UIView *)lianxiMessageShareView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*2/5, 50)];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.7]];
    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
    [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*2/5,0, kWidth*2/5, 50)];
    [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:NavColor];
    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];
    [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*4/5,0, kWidth*1/5, 50)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:yellowButtonColor];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareBtn];


    [self.view addSubview:view];
    return view;
}

-(UIView *)laobanViewWithPrice:(float)price
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/2, 50)];
    [messageBtn setTitle:[NSString stringWithFormat:@"¥%.1f",price] forState:UIControlStateNormal];
    [messageBtn setTitleColor:yellowButtonColor forState:UIControlStateNormal];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
    [view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2,0, kWidth/2, 50)];
    
    [phoneBtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
    [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:yellowButtonColor];
    [phoneBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];
    
    [self.view addSubview:view];
    return view;
}
-(UIView *)laobanShareViewWithPrice:(float)price
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*2/5, 50)];
    [messageBtn setTitle:[NSString stringWithFormat:@"¥%.1f",price] forState:UIControlStateNormal];
    [messageBtn setTitleColor:yellowButtonColor forState:UIControlStateNormal];
    [messageBtn setBackgroundColor:[UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1]];
    [view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*2/5,0, kWidth*2/5, 50)];
    [phoneBtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
    [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:yellowButtonColor];
    [phoneBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];

    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*4/5,0, kWidth*1/5, 50)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:NavColor];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareBtn];

    [self.view addSubview:view];
    return view;
}

-(void)buyAction
{
    if (![APPDELEGATE isNeedLogin]) {
        [ToastView showTopToast:@"请先登录"];
        LoginViewController *loginViewC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewC animated:YES];
        return;
    }
    [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            float moneyNum =[[[responseObject objectForKey:@"result"] objectForKey:@"money"]floatValue];
            if (moneyNum<self.model.buyPrice) {
                [ToastView showTopToast:@"您的余额不足，请先充值"];
                
                ZIKPayViewController *zikPayVC=[[ZIKPayViewController alloc]init];
                [self.navigationController pushViewController:zikPayVC animated:YES];
                return ;
            }
            _buyAlertView =[BuyMessageAlertView addActionVieWithPrice:[NSString stringWithFormat:@"%.1f",self.model.buyPrice               ] AndMone:[NSString stringWithFormat:@"%.1f",moneyNum]];
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
            [ToastView showTopToast:@"购买成功"];
            ShowActionV();
    [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                                WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                    //NSLog(@"%@",responseObject);
                                    RemoveActionV();
                                    NSDictionary *dic=[responseObject objectForKey:@"result"];
                                    self.infoDic=dic;
                                    self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"]];
                                    self.model.uid=self.uid;
                                    if (self.model.push||self.model.buy) {
                                        self.isPuy=YES;
                                        _biaoqianView.hidden=NO;
                                        if (self.model.push) {
                                            [_biaoqianView setImage:[UIImage imageNamed:@"dibgzhibiaoqian"]];
                                        }
                                        if (self.model.buy) {
                                            [_biaoqianView setImage:[UIImage imageNamed:@"buybiaoqian"]];
                                        }
                                    }else
                                    {
                                        self.isPuy=NO;
                                    }
                                    if (!self.isPuy) {
                                        if (_BuyMessageView==nil) {
                                            _BuyMessageView =[self laobanShareViewWithPrice:self.model.buyPrice];
                                            [_messageView removeFromSuperview];
                                            _messageView = nil;
                                        }
                                    }else{
                                        if (_messageView==nil) {
                                            _messageView = [self lianxiMessageShareView];
                                            [_BuyMessageView removeFromSuperview];
                                            _BuyMessageView = nil;
                                        }
                                    }
                                    [self reloadMyView];
                                } failure:^(NSError *error) {
                                    RemoveActionV();
                                }];


        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    [BuyMessageAlertView removeActionView];
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
                //NSLog(@"str======%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"sms://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self showMessageView:[NSArray arrayWithObjects:[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"], nil] title:@"苗木求购" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的求购信息:%@ 很感兴趣",[[self.infoDic objectForKey:@"detail"] objectForKey:@"productName"]]];
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


-(void)reloadMyView
{
    if (_BuyMessageView == nil && _messageView == nil && myshareBtn == nil) {
        self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64);
    }
    if (self.type==1) {
        if (self.model.state==1) {
            [self.guoqiIamgV setImage:[UIImage imageNamed:@"guoqibiaoqian"]];
            if (self.model.state==1) {
                self.guoqiIamgV.hidden=NO;
            }else{
                self.guoqiIamgV.hidden=YES;
            }
        }
        if (self.model.state == 5) {//已删除
            [self.guoqiIamgV setImage:[UIImage imageNamed:@"已删除-2"]];
            _BuyMessageView.hidden = YES;
            _messageView.hidden = YES;
            _biaoqianView.hidden = YES;
            self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64);
        }

    }
    if (self.type==2) {
        if (self.model.state==1||self.model.state==3) {
            //1 已过期  可编辑 3 未通过  可编辑
            [self.guoqiIamgV setImage:[UIImage imageNamed:@"guoqibiaoqian"]];
            if (self.model.state==1) {
                self.guoqiIamgV.hidden=NO;
            }else{
                self.guoqiIamgV.hidden=YES;
            }
            [self.editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.editingBtn addTarget:self action:@selector(editingBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.model.state==0||self.model.state==4||self.model.state==2) {
            //0  已关闭 可打开  4 审核通过 可关闭
            [self.guoqiIamgV setImage:[UIImage imageNamed:@"guanbibiaoqian"]];
            [self.editingBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [self.editingBtn setTitle:@"" forState:UIControlStateHighlighted];
            [self.editingBtn setTitle:@"打开" forState:UIControlStateSelected];
            [self.editingBtn addTarget:self action:@selector(openAndColseBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (self.model.state==0) {
                self.editingBtn.selected=YES;
                self.guoqiIamgV.hidden=NO;
            }
            if (self.model.state==2||self.model.state==4) {
                self.editingBtn.selected=NO;
                self.guoqiIamgV.hidden=YES;
            }
        }
    }
    NSString *titleStr=[[self.infoDic objectForKey:@"detail"] objectForKey:@"title"];
    [self.navTitleLab setText:titleStr];
    
    if ([[[self.infoDic objectForKey:@"detail"] objectForKey:@"collect"] integerValue]) {
        self.collectionBtn.selected=YES;
    }
    self.specAry=[[self.infoDic objectForKey:@"detail"]objectForKey:@"spec"];
    _miaomuzhiAry=[NSMutableArray array];
    for (int i=0; i<self.specAry.count; i++) {
        NSDictionary *dic=self.specAry[i];
        NSArray *aryyyyy=[dic objectForKey:@"value"];
        if (![[aryyyyy firstObject] isEqualToString:@"不限"]) {
            [_miaomuzhiAry addObject:dic];
        }
    }
    NSArray *rocomAry=[self.infoDic objectForKey:@"list"];
    self.recommendeAry = [HotBuyModel creathotBuyModelAryByAry:rocomAry];
     [self.tableView reloadData];
    
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:10 right:60 bottom:10 left:10];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"求购详情"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    self.navTitleLab=titleLab;
    [view addSubview:titleLab];
    if (self.type==2) {
         UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
        [editingBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        self.editingBtn=editingBtn;
        [view addSubview:editingBtn];
    }else
    {
        UIButton *collectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 26, 30, 30)];
        [collectionBtn setEnlargeEdgeWithTop:0 right:5 bottom:0 left:15];
        self.collectionBtn = collectionBtn;
        [collectionBtn setImage:[UIImage imageNamed:@"collectionN"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"collectionT"] forState:UIControlStateSelected];
        [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:collectionBtn];
    }
    
    return view;
}
-(void)editingBtn:(UIButton *)sender
{
    if (self.model.state==1||self.model.state==3) {
        self.model.uid=self.uid;
        buyFabuViewController *buyFabuVC=[[buyFabuViewController alloc]initWithModel:self.model];
        [self.navigationController pushViewController:buyFabuVC animated:YES];
    }else{
        [ToastView showTopToast:@"该条求购不可编辑"];
        return;
    }
    
}
-(void)openAndColseBtn:(UIButton *)sender
{
    if (sender.selected==YES) {
        [HTTPCLIENT openMyBuyMessageWithUids:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"打开成功"];
                sender.selected=NO;
                self.guoqiIamgV.hidden=YES;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
        return;
    }
    if(sender.selected==NO)
    {
        [HTTPCLIENT closeMyBuyMessageWithUids:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"关闭成功"];
                sender.selected=YES;
                self.guoqiIamgV.hidden=NO;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }

        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)collectionBtn:(UIButton *)sender
{
    if(![APPDELEGATE isNeedLogin])
    {
        [ToastView showTopToast:@"请先登录"];
        return;
    }
    if (sender.selected==NO) {
        [HTTPCLIENT collectBuyWithSupplyID:self.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
                [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                 WithType:@"0" WithmemberCustomUid:@""
                                     Success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        self.infoDic=[responseObject objectForKey:@"result"];
                    }else{
                        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
        return;
    }
    
    
    if (sender.selected) {
        [HTTPCLIENT deletesenderCollectWithIds:[[self.infoDic objectForKey:@"detail"] objectForKey:@"collectUid"] Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type==2) {
        return 4;
    }
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return self.recommendeAry.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        BuyUserInfoTableViewCell *cell=[[BuyUserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.infoDic) {
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.infoDic objectForKey:@"detail"]];
            if(!_isPuy&&self.type==1)
            {
                if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                    
                }else
                {
                    [dic setValue:@"请付费查看" forKey:@"supplybuyName"];
                }
                
            }
            cell.dic=dic;
        }
        return cell;
    }else if(indexPath.section==1)
    {
        BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.specAry.count*30+40) andName:self.model.productName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.specAry) {
//            if (_isShow) {
                cell.ary=self.specAry;
//            }else{
//                cell.ary=self.miaomuzhiAry;
//            }
            
        }
        return cell;
    }else if (indexPath.section==2)
    {
        QIYeMessageTableViewCell *cell=[[QIYeMessageTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 140)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.infoDic) {
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.infoDic objectForKey:@"detail"]];
            if(!_isPuy&&self.type==1)
            {
                if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                    
                }else
                {
                    [dic setValue:@"请付费查看" forKey:@"address"];
                    [dic setValue:@"请付费查看" forKey:@"phone"];
                }
                
            }
            cell.dic=dic;
        }
        return cell;
    }else if(indexPath.section==3)
    {
        
        NSString *labelText=[[self.infoDic objectForKey:@"detail"] objectForKey:@"description"];
        if (labelText.length==0) {
            labelText=@"暂无";
        }
      CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
      
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        [cellLab setTextColor:titleLabColor];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
        return cell;

    }
    if (indexPath.section==4) {
        BuySearchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[BuySearchTableViewCell IDStr]];
        if (!cell) {
            cell=[[BuySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BuySearchTableViewCell IDStr]  WithFrame:CGRectMake(0, 0, kWidth, 60)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HotBuyModel *model=self.recommendeAry[indexPath.row];
        cell.hotBuyModel=model;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
//-(void)showOtherMessageAction:(UIButton *)sender
//{
//    
//    self.isShow=!self.isShow;
//    //一个section刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    if (indexPath.section==1) {
        if (self.specAry) {
//            if (_isShow) {
                return self.specAry.count*30+40;
//            }else{
//                return _miaomuzhiAry.count*30+40;
//            }
            
        }
    }if (indexPath.section==2) {
        //return 140;
        NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.infoDic objectForKey:@"detail"]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize size = [dic[@"address"] boundingRectWithSize:CGSizeMake(kWidth-130-15, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size.height+110;

    }
    if(indexPath.section==3)
    {
        NSString *labelText=[[self.infoDic objectForKey:@"detial"] objectForKey:@"description"];
        if (labelText) {
            return  [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
        }
        else{
            return 40;
        }
       
    }
    if (indexPath.section==4) {
        return 60;
    }
    return 10;
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
        UILabel *rightLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-160, 0, 155, 30)];
        [rightLab setFont:[UIFont systemFontOfSize:12]];
        [rightLab setTextColor:titleLabColor];
        [rightLab setTextAlignment:NSTextAlignmentRight];
        [rightLab setText:@"供应信息可分享到微信、QQ"];
        [view addSubview:rightLab];
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"备注";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if (section==4) {
        return 50;
    }else{
    return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        HotBuyModel *model=self.recommendeAry[indexPath.row];
        BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
        [self.navigationController pushViewController:vc animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareBtnClick {
//    self.type 1 热门求购  2我的求购
//    self.isPuy YES 已定制或已付款  NO 未付款且未定制
//    self.model.state  4 已通过
    [self requestShareData];
}
#pragma mark - 求购分享
- (void)requestShareData {
    ShowActionV();
    NSString *state = nil;
    if (self.type == 1 && self.model.push != 1 && self.model.buy != 1 ) {//:热门求购（热门求购中除去已定制和已购买的）
        state = @"1";
    }
    else if (self.type == 2) {//我的求购
        state = @"2";
    }
    else if (self.model.push == 1) {//已定制
        state = @"3";
    }
    else if (self.model.buy == 2) {//已购买
        state  = @"4";
    }
    [HTTPCLIENT buyShareWithUid:self.uid state:state Success:^(id responseObject) {
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
