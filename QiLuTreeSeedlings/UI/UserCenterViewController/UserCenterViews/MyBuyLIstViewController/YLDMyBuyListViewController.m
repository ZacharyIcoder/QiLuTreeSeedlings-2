//
//  YLDMyBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDMyBuyListViewController.h"
#import "buyFabuViewController.h"
@interface YLDMyBuyListViewController ()

@end

@implementation YLDMyBuyListViewController
-(void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self creatScrollerViewBtn];
    // Do any additional setup after loading the view.
}
-(void)creatScrollerViewBtn
{
    UIScrollView *topScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [topScrollView setBackgroundColor:[UIColor whiteColor]];
    topScrollView.tag=111;
    topScrollView.showsVerticalScrollIndicator=NO;
    topScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:topScrollView];
}
- (void)configNav {
    self.vcTitle = @"我的求购";
    self.rightBarBtnTitleString = @"发布";
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    self.rightBarBtnBlock = ^{
        if (APPDELEGATE.isCanPublishBuy==NO&&[APPDELEGATE isNeedCompany]==NO)
        {
            [ToastView showTopToast:@"您没有求购发布权限,请先完善公司或苗圃信息"];
            return;
        }
        buyFabuViewController *buyFaBuVC=[[buyFabuViewController alloc]init];
        [weakSelf.navigationController pushViewController:buyFaBuVC animated:YES];
    };
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
