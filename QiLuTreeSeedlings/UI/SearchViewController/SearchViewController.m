//
//  SearchViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchViewController.h"
#import "UIDefines.h"
#import "SearchRecommendView.h"
#import "searchHistoryViewCell.h"
#import "SearchSuccessView.h"
#import "ScreeningView.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "HttpClient.h"

//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享

#import "YLDLoginViewController.h"
#import "UINavController.h"


@interface SearchViewController ()<UITextFieldDelegate,SearchRecommendViewDelegate,SearchSuccessViewDelegatel,ScreeningViewDelegate,UMSocialUIDelegate>
@property (nonatomic,weak) UIButton *chooseSBBtn;
@property (nonatomic,copy) NSString *searchStr;
@property (nonatomic,strong) SearchSuccessView *searchSuccessView;
@property (nonatomic,strong) SearchRecommendView *searchRecommendView;
@property (nonatomic,strong)UITextField *searchMessageField;
@property (nonatomic) NSInteger searchType;
@property (nonatomic,weak) ScreeningView *screeningView;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url

@end

@implementation SearchViewController
-(void)dealloc
{
     
}
-(id)initWithSearchType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.searchType=type;
        if (self.searchRecommendView) {
            [self.searchRecommendView removeFromSuperview];
            self.searchRecommendView=nil;
        }
        
        if (!self.searchSuccessView) {
            self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
            self.searchSuccessView.delegate=self;
            [self.view addSubview:self.searchSuccessView];
        }

        if(type==1)
        {
            [self.searchSuccessView searchViewActionWithSearchType:type];
            
        }
        if (type==2) {
            [self.searchSuccessView searchViewActionWithSearchType:type];
        }
    }
    return self;
}
-(id)initWithSearchType:(NSInteger)type andSaerChStr:(NSString *)searchStr
{
    self=[super init];
    if (self) {
        self.searchType=type;
        
        self.searchStr=searchStr;
       
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        self.searchSuccessView.delegate=self;
        [self.view addSubview:self.searchSuccessView];
        if (self.searchStr.length==0) {
            [HTTPCLIENT hotkeywordWithkeywordCount:@"10" Success:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSDictionary *Dic =[responseObject objectForKey:@"result"];
                    NSArray *ary=[Dic objectForKey:@"productList"];
                    SearchRecommendView *searchRView=[[SearchRecommendView
                                                       alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) WithAry:ary];
                    self.searchRecommendView=searchRView;
                    searchRView.delegate=self;
                    [self.view addSubview:searchRView];

                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }else
        {
            if (!self.searchSuccessView) {
                self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
                [self.view addSubview:self.searchSuccessView];
            }
            [self.searchSuccessView searchViewActionWith:searchStr AndSearchType:type];
        }
        
        

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *searchView=[self makeSearchNavView];
    [self.view addSubview:searchView];
    if(self.searchType==2)
    {
        [self.chooseSBBtn setTitle:@"求购" forState:UIControlStateNormal];
    }
    if(self.searchType==1)
    {
        [self.chooseSBBtn setTitle:@"供应" forState:UIControlStateNormal];
    }
    if (self.searchStr.length>0) {
       _searchMessageField.text=self.searchStr;
    }
//     _searchMessageField.text=@"柳树";
    //[self.view bringSubviewToFront:screeningV];

}
#pragma mark-点击进入详情页面
-(void)SearchSuccessViewPushBuyDetial:(NSString *)uid
{
    //NSLog(@"buydetial:%@",uid);
    BuyDetialInfoViewController *viewC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:uid];
    [self.navigationController pushViewController:viewC animated:YES];
}

-(void)SearchSuccessViewPushSellDetial:(HotSellModel *)uid
{
    SellDetialViewController *viewC=[[SellDetialViewController alloc]initWithUid:uid];
    [self.navigationController pushViewController:viewC animated:YES];
}
#pragma mark-生成搜索栏
-(UIView *)makeSearchNavView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(17, 27, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[view setBackgroundColor:[UIColor greenColor]];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(60, 25, kWidth-120, 44-10)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=3;
    [view addSubview:backView];
    //选择搜索方式的按钮－供应或者求购
    UIButton *chooseSBBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 34)];
    [chooseSBBtn setTitle:@"供应" forState:UIControlStateNormal];
    //[chooseSBBtn setBackgroundColor:[UIColor grayColor]];
    [chooseSBBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [chooseSBBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.chooseSBBtn=chooseSBBtn;
    [chooseSBBtn addTarget:self action:@selector(chooseSBBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:chooseSBBtn];
    UIImageView *lineV=[[UIImageView alloc]initWithFrame:CGRectMake(60, 3, 0.5, 28)];
    [lineV setBackgroundColor:kLineColor];
    [backView addSubview:lineV];
     UITextField * searchMessageField=[[UITextField alloc]initWithFrame:CGRectMake(65, 0, backView.frame.size.width-100, 34)];
    self.searchMessageField=searchMessageField;
    searchMessageField.placeholder=@"请输入树种名称";
    searchMessageField.delegate=self;
    [searchMessageField setTextColor:titleLabColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchMessageField];

    ////////
    //searchMessageField.text=@"油松";
    
    
    
    searchMessageField.tag=1001;
    [searchMessageField setFont:[UIFont systemFontOfSize:14]];
    searchMessageField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [backView addSubview:searchMessageField];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-45, 0, 40,34)];
    [searchBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [searchBtn setImage:[UIImage imageNamed:@"searchBtnAction"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchBtn];
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-25, 30, 20, 20)];
    [screenBtn setEnlargeEdgeWithTop:15 right:10 bottom:10 left:30];
    [screenBtn setImage:[UIImage imageNamed:@"screenBtnAction"] forState:UIControlStateNormal];
    UILabel *labee=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-53, 30, 30, 20)];
    [labee setFont:[UIFont systemFontOfSize:14]];
    [labee setTextColor:[UIColor whiteColor]];
    labee.text=@"筛选";
    [view addSubview:labee];
    [screenBtn addTarget:self action:@selector(screeingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:screenBtn];
    return view;
}
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    if ([textField.text isEqualToString:@""] || textField.text.length == 0) {
        [HTTPCLIENT hotkeywordWithkeywordCount:@"10" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *Dic =[responseObject objectForKey:@"result"];
                NSArray *ary=[Dic objectForKey:@"productList"];
                if (!self.searchRecommendView) {
                    SearchRecommendView *searchRView = [[SearchRecommendView
                                                         alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) WithAry:ary];
                    self.searchRecommendView=searchRView;
                    searchRView.delegate=self;
                    [self.view addSubview:searchRView];
                }

            }

        } failure:^(NSError *error) {

        }];

        //(void)[self initWithSearchType:self.searchType];
    }
}
-(void)screeingBtnAction
{
    if (self.screeningView) {
        [self.screeningView setSearchStr:self.searchMessageField.text];
        if (self.screeningView.superview==nil) {
            [self.view addSubview:self.screeningView];
        }
    }else{
      ScreeningView *screeningV=[[ScreeningView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight) andSearch:self.searchMessageField.text andSerachType:self.searchType];
        self.screeningView=screeningV;
        screeningV.delegate=self;
        [self.view addSubview:self.screeningView];
    }
    
//    screeningV.
    
    
    [self.screeningView showViewAction];
}
-(void)ScreeningbackBtnAction
{
    self.screeningView=nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1001) {
        if (textField.text.length==0) {
            return;
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1001) {
        return [textField resignFirstResponder];
    }
    return [textField resignFirstResponder];
}
-(void)chooseSBBtnAction
{
    UIAlertController *alertV= [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择搜索类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sellAction=[UIAlertAction actionWithTitle:@"供应" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.chooseSBBtn setTitle:@"供应" forState:UIControlStateNormal];
        if (self.searchType!=1) {
            self.searchType=1;
            if (self.screeningView) {
                [self.screeningView removeFromSuperview];
                self.screeningView=nil;
            }
            if (self.searchSuccessView) {
                self.searchSuccessView.searchType = 1;
            }
        }
        
    }];
    UIAlertAction *buyAction=[UIAlertAction actionWithTitle:@"求购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.chooseSBBtn setTitle:@"求购" forState:UIControlStateNormal];
        if (self.searchType!=2) {
            self.searchType=2;
            if (self.screeningView) {
                [self.screeningView removeFromSuperview];
                self.screeningView=nil;
            }
            if (self.searchSuccessView) {
                self.searchSuccessView.searchType = 2;
            }
        }
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertV addAction:sellAction];
    [alertV addAction:buyAction];
    [alertV addAction:cancelAction];
    
    [self presentViewController:alertV animated:YES completion:^{
        
    }];
}


-(void)searchBtnAction:(UIButton *)sender
{
    if (self.searchMessageField.text.length==0) {
        [ToastView showTopToast:@"请输入搜索内容"];
        [self.searchMessageField becomeFirstResponder];
        
        return;
    }

    [self.searchMessageField resignFirstResponder];
    [self SearchActionWithString:self.searchMessageField.text];
    
    
}
- (void)SearchActionWithString:(NSString *)searchStr
{
    if (self.searchRecommendView) {
        [self.searchRecommendView removeFromSuperview];
        self.searchRecommendView=nil;
    }
    
    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        [self.view addSubview:self.searchSuccessView];
    }
    [self.searchSuccessView searchViewActionWith:searchStr AndSearchType:self.searchType];
    
}
-(void)creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName
{
    if (self.searchRecommendView) {
        [self.searchRecommendView removeFromSuperview];
        self.searchRecommendView=nil;
    }
    
    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        [self.view addSubview:self.searchSuccessView];
    }
    self.searchMessageField.text=productName;
    self.searchSuccessView.province=province;
    self.searchSuccessView.searchStr=productName;
    self.searchSuccessView.county=county;
    self.searchSuccessView.City=city;
    self.searchSuccessView.goldsupplier=goldsupplier;
    self.searchSuccessView.productUid=productUid;
    self.searchSuccessView.shaixuanAry=ary;

    [self.searchSuccessView searchViewActionWith:productName AndSearchType:self.searchType];
}
-(void)SearchRecommendViewSearch:(NSString *)searchStr
{
    if (self.searchRecommendView) {
        [self.searchRecommendView removeFromSuperview];
        self.searchRecommendView=nil;
    }
    
    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        [self.view addSubview:self.searchSuccessView];
    }
    self.searchMessageField.text=searchStr;
    [self.searchSuccessView searchViewActionWith:searchStr AndSearchType:self.searchType];
}
-(void)SearchRecommendViewSearchDIC:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
   // NSInteger type=[[dic objectForKey:@"type"] integerValue];
    //self.searchType=type+1;
    if (self.searchRecommendView) {
        [self.searchRecommendView removeFromSuperview];
        self.searchRecommendView=nil;
    }
    
    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        [self.view addSubview:self.searchSuccessView];
    }
    self.searchMessageField.text=[dic objectForKey:@"productName"];
    [self.searchSuccessView searchViewActionWith:[dic objectForKey:@"productName"] AndSearchType:self.searchType];
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)canUmshare {
                YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc] init];
                [ToastView showTopToast:@"请先登录"];
                UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
    
                [self presentViewController:navVC animated:YES completion:^{
    
                }];
                return;

}
- (void)umshare:(NSString *)shareText title:(NSString *)shareTitle image:(UIImage *)shareImage url:(NSString *)shareUrl {

    self.shareText  = shareText;
    self.shareTitle = shareTitle;
    self.shareImage = shareImage;
    self.shareUrl   = shareUrl;
    [self umengShare];
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
