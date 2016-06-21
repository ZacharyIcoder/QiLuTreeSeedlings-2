//
//  YLDGongChengAnLiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongChengAnLiViewController.h"
#import "YLDGongChengAnLiCell.h"
#import "MJRefresh.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface YLDGongChengAnLiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic)NSInteger pageNum;
@end

@implementation YLDGongChengAnLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"工程案例";
    self.dataAry=[NSMutableArray array];
    self.pageNum=1;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDGongChengAnLiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongChengAnLiCell"];
    if (!cell) {
        cell=[YLDGongChengAnLiCell yldGongChengAnLiCell];
    }
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
