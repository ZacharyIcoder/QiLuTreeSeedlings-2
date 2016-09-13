//
//  YLDJPGYSInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSInfoViewController.h"
#import "HttpClient.h"
@interface YLDJPGYSInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSDictionary *dic;
@end

@implementation YLDJPGYSInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"金牌信息";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
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
