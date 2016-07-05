//
//  LYDGCGSTiShiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "LYDGCGSTiShiViewController.h"
#import "UIDefines.h"
#import "YLDShengJiViewViewController.h"
@interface LYDGCGSTiShiViewController ()

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
    [kefuBtn setTitle:@"客服电话0539-11111111" forState:UIControlStateNormal];
    [kefuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
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
    // Do any additional setup after loading the view from its nib.
}
-(void)callAction
{
    
}
-(void)shengjiAction
{
    YLDShengJiViewViewController *yldsda=[YLDShengJiViewViewController new];
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
