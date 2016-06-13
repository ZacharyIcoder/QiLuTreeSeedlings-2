//
//  WoDeDingDanViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "WoDeDingDanViewController.h"
#import "UIDefines.h"
#import "MJRefresh.h"
@interface WoDeDingDanViewController ()
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WoDeDingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的订单";
    // Do any additional setup after loading the view from its nib.
}
-(void)MakeCCCvIEW
{
    UIView *ssssVieWWW=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [self.view addSubview:ssssVieWWW];
    
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
