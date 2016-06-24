//
//  YLDShengJiViewViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShengJiViewViewController.h"
#import "UIDefines.h"
#import "YLDShenFenShuoMingCell.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
@interface YLDShengJiViewViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLDShengJiViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"身份升级";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDShenFenShuoMingCell *cell=[YLDShenFenShuoMingCell yldShenFenShuoMingCell];
    if (indexPath.row==0) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"工作站身份简介";
        dic[@"detial"]=@"工作站是齐鲁苗木网苗木销售认证服务商，可提供某某功能";
        cell.dic=dic;
        cell.shengjiBtn.tag=0;
        [cell.shengjiBtn addTarget:self action:@selector(shengjiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row==1) {
        NSMutableDictionary *dic=[NSMutableDictionary new];
        dic[@"title"]=@"工作站身份简介";
        dic[@"detial"]=@"工程公司介绍莫某某功能";
        cell.dic=dic;
        cell.shengjiBtn.tag=1;
        [cell.shengjiBtn addTarget:self action:@selector(shengjiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)shengjiBtnAction:(UIButton *)sender
{
    if (sender.tag==0) {
        [ToastView showTopToast:@"暂未开放此功能"];
    }
    if (sender.tag==1) {
        YLDGCGSZiZhiTiJiaoViewController *yldVC=[[YLDGCGSZiZhiTiJiaoViewController alloc]init];
        [self.navigationController pushViewController:yldVC animated:YES];
    }
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
