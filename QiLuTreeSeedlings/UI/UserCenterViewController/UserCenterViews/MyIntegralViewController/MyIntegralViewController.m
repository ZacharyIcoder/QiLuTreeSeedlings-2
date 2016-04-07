//
//  MyIntegralViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyIntegralViewController.h"

@interface MyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *zongjifenLab;
@property (nonatomic,strong) UITableView *integralTableView;
@property (nonatomic) NSInteger pamgeNum;
@end

@implementation MyIntegralViewController
@synthesize pamgeNum;
-(void)viewWillAppear:(BOOL)animated
{
    pamgeNum=1;
    [self getDataList];
}
-(void)getDataList
{
    [HTTPCLIENT getMyIntegralListWithPageNumber:[NSString stringWithFormat:@"%ld",pamgeNum] Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            [self.zongjifenLab setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sumscore"]]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle=@"我的积分";
    UIView *zongjifenView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 100)];
    [zongjifenView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:zongjifenView];
    UILabel *labxx=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, kWidth, 20)];
    [labxx setTextAlignment:NSTextAlignmentCenter];
    [labxx setTextColor:[UIColor blackColor]];
    [labxx setFont:[UIFont systemFontOfSize:17]];
    [labxx setText:@"总积分"];
    [zongjifenView addSubview:labxx];
    UILabel *zongjifenLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, kWidth, 30)];
    [zongjifenLab setFont:[UIFont systemFontOfSize:22]];
    [zongjifenLab setTextColor:yellowButtonColor];
    [zongjifenLab setText:@"0"];
    [zongjifenLab setTextAlignment:NSTextAlignmentCenter];
    [zongjifenView addSubview:zongjifenLab];
    self.zongjifenLab=zongjifenLab;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, kWidth, kHeight-100-70) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.integralTableView=tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
