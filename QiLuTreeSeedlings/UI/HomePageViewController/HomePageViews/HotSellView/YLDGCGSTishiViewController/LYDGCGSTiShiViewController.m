//
//  LYDGCGSTiShiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "LYDGCGSTiShiViewController.h"
#import "UIDefines.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "HttpClient.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface LYDGCGSTiShiViewController ()
@property (nonatomic,copy)NSString *phone;
@end

@implementation LYDGCGSTiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"友情提示";
    UIScrollView *backSvrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:backSvrollV];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-65, 98, 130, 140)];
    [iamgeV setImage:[UIImage imageNamed:@"图片1.png"]];
    [backSvrollV addSubview:iamgeV];
    UILabel *tixinglab=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(iamgeV.frame)+10, kWidth-40, 60)];
    [tixinglab setFont:[UIFont systemFontOfSize:15]];
    [tixinglab setTextColor:detialLabColor];
    [tixinglab setText:@"抱歉，您不是齐鲁苗木网工程公司用户，暂时无法使用工程助手功能。\n  您可以在线提交资质信息，由管理员审核通过后获得工程公司身份，是否升级。"];
    tixinglab.numberOfLines=0;
     [tixinglab sizeToFit];
    [backSvrollV addSubview:tixinglab];
    UIButton *kefuBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tixinglab.frame) +10, kWidth, 50)];
    [HTTPCLIENT kefuXiTongWithPage:@"2" WithPageNumber:@"1" WithIsLoad:@"0" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            NSInteger type=[[dic objectForKey:@"type"] integerValue];
            if (type==2) {
                NSDictionary *dic2=[dic objectForKey:@"kehu"];
                self.phone=dic2[@"phone"];
//                self.nameLab.text=[dic2 objectForKey:@"name"];
//                [self normalViewWithDic:dic2];
                 [kefuBtn setTitle:[NSString stringWithFormat:@"客服电话%@",self.phone] forState:UIControlStateNormal];
            }
            if (type==1) {
                [ToastView showTopToast:@"您本身是齐鲁苗木网客服人员"];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];

    [kefuBtn setTitle:@"客服电话0539-0000000" forState:UIControlStateNormal];
    [kefuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    [kefuBtn setEnlargeEdgeWithTop:3 right:10 bottom:3 left:10];
    [kefuBtn setImage:[UIImage imageNamed:@"dingdandinahua"] forState:UIControlStateNormal];
    [kefuBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    [backSvrollV addSubview:kefuBtn];
    
    UIButton *shengjiBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(kefuBtn.frame)+10, kWidth-80, 45)];
    [shengjiBtn setBackgroundColor:NavColor];
    [shengjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shengjiBtn setImage:[UIImage imageNamed:@"升级箭头"] forState:UIControlStateNormal];
    [shengjiBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    [shengjiBtn addTarget:self action:@selector(shengjiAction) forControlEvents:UIControlEventTouchUpInside];
    [backSvrollV addSubview:shengjiBtn];
    UIButton *quxiaobtn=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(shengjiBtn.frame)+10, kWidth-80, 45)];
    [quxiaobtn setBackgroundColor:[UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1]];
    [quxiaobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaobtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [backSvrollV addSubview:quxiaobtn];
    [backSvrollV setContentSize:CGSizeMake(0, CGRectGetMaxY(quxiaobtn.frame)+10)];
    // Do any additional setup after loading the view from its nib.
}
-(void)callAction
{
   if (self.phone.length>0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else
    {
        [ToastView showTopToast:@"暂无联系方式"];
    }
}
-(void)shengjiAction
{
    YLDGCGSZiZhiTiJiaoViewController *yldsda=[YLDGCGSZiZhiTiJiaoViewController new];
    [self.navigationController pushViewController:yldsda animated:YES];
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
