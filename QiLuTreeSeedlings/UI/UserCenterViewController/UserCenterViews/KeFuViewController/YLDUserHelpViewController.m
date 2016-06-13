//
//  YLDUserHelpViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDUserHelpViewController.h"
#import "YLDHelpDetialViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
@interface YLDUserHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataAry;
@end

@implementation YLDUserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"使用帮助";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    [HTTPCLIENT userHelpSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dataAry=[responseObject objectForKey:@"result"];
            [tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"userhelpcell"];
    if(!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userhelpcell"];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setTextColor:DarkTitleColor];
    }
    NSDictionary *dic=self.dataAry[indexPath.section];
    cell.textLabel.text=[dic objectForKey:@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=self.dataAry[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLDHelpDetialViewController *HelpDetialVC=[[YLDHelpDetialViewController alloc]initWithDic:dic];
    [self.navigationController pushViewController:HelpDetialVC animated:YES];
    
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
