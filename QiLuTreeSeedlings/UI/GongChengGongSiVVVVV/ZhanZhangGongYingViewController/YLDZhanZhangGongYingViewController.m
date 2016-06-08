//
//  YLDZhanZhangGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangGongYingViewController.h"
#import "AdvertView.h"
@interface YLDZhanZhangGongYingViewController ()<AdvertDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation YLDZhanZhangGongYingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setTitle:@"苗信通" forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.backBtn.frame=CGRectMake(13, 26, 60, 30);
    [self.navBackView setBackgroundColor:NavYellowColor];
    self.vcTitle=@"站长供应";
    

//            [self.view addSubview:adView];

    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0) {
//        return 160.f/320.f*kWidth;
//    }
    if (indexPath.section==0) {
        return 160.f/320.f*kWidth;
    }
    if (indexPath.section==1) {
        return 70;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 160.f/320.f*kWidth)];
            adView.delegate=self;
            [adView setAdInfo];
            [adView adStart];
            return adView;
        }
    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    return cell;
}
- (void)advertPush:(NSInteger)index
{
    
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
