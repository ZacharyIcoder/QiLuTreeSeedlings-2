//
//  YLDJPZhongXinViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPZhongXinViewController.h"
#import "YLDJPGYSDBigCell.h"
#import "HttpClient.h"
#import "UIDefines.h"
@interface YLDJPZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSDictionary *dic;
@end

@implementation YLDJPZhongXinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, kWidth, kHeight-50) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 200;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDJPGYSDBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJPGYSDBigCell"];
        
        if (!cell) {
            cell=[YLDJPGYSDBigCell YLDJPGYSDBigCell];
        }
        return cell;
    }
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
