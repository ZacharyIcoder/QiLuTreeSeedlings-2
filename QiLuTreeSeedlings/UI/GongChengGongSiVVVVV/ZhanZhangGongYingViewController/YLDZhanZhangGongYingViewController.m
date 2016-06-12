//
//  YLDZhanZhangGongYingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangGongYingViewController.h"
#import "AdvertView.h"
#import "UIDefines.h"
@interface YLDZhanZhangGongYingViewController ()<AdvertDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation YLDZhanZhangGongYingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.frame=CGRectMake(13, 26, 60, 30);
    self.vcTitle=@"站长供应";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    if (indexPath.section==2) {
        return 110;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.001;
    }
    return 36;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view=[self makeTitleViewWithTitle:@"推荐工作站" AndColor:kRedHintColor andY:0];
        return view;
    }
    if (section==2) {
        UIView *view=[self makeTitleViewWithTitle:@"工作站供应" AndColor:NavColor andY:0];
        return view;
    }
    UIView *view=[[UIView alloc]init];
    
    return view;
}
//构建小标题栏
-(UIView *)makeTitleViewWithTitle:(NSString *)title AndColor:(UIColor *)color andY:(CGFloat )y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, y, kWidth, 36)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 5, 22)];
    [imageV setBackgroundColor:color];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 36)];
    titleLab.text=title;
    [titleLab setTextColor:color];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLab];
//    if ([title isEqualToString:@"猜你喜欢"]) {
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-160, 0, 150,36)];
//        [lab setFont:[UIFont systemFontOfSize:12]];
//        [lab setTextColor:titleLabColor];
//        lab.text=@"供应信息可分享到微信,QQ";
//        [lab setTextAlignment:NSTextAlignmentCenter];
//        [view addSubview:lab];
//    }
//    if ([title isEqualToString:@"热门求购"]) {
//        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 0, 120,36)];
//        [lab setFont:[UIFont systemFontOfSize:14]];
//        [lab setTextColor:titleLabColor];
//        [lab setTextAlignment:NSTextAlignmentCenter];
//        lab.text=@"下拉刷新";
//        [view addSubview:lab];
//    }
    return view;
    
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
