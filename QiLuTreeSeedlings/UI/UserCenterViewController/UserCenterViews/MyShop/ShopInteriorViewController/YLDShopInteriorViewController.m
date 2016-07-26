//
//  YLDShopInteriorViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopInteriorViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "UIImageView+AFNetworking.h"
@interface YLDShopInteriorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *dic;
@end

@implementation YLDShopInteriorViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [HTTPCLIENT getShopInoterMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[responseObject objectForKey:@"result"];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"店铺装修";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    
    [self.view addSubview:tableView];
    ShowActionV();
    // Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld",indexPath.row]];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"UITableViewCell%ld",indexPath.row]];
        CGRect frame=cell.frame;
        frame.size.height=50;
        cell.frame=frame;
        UIView *lineImagV=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kWidth-20, 0.5)];
        [lineImagV setBackgroundColor:kLineColor];
        [cell addSubview:lineImagV];
        cell.textLabel.textColor=titleLabColor;
        cell.detailTextLabel.textColor=detialLabColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==1) {
            UIImageView *zhaopaiImageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-200, 10, 190, 30)];
            zhaopaiImageV.tag=100;
            [cell.contentView addSubview:zhaopaiImageV];
        }
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"基本信息";
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"店铺招牌";
        NSString *backUrl=[self.dic objectForKey:@"background"];
        if (backUrl.length>0) {
            UIImageView *iamgeV=[cell.contentView viewWithTag:100];
            [iamgeV setImageWithURL:[NSURL URLWithString:backUrl]];
        }
    }
    if (indexPath.row==2) {
//        cell.
        cell.textLabel.text=@"推荐供应管理";
        if (self.dic) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld/10",[[self.dic objectForKey:@"supplyCount"] integerValue]];
        }else{
            cell.detailTextLabel.text=@"0/10";
        }
    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"推荐求购管理";
        if (self.dic) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld/10",[[self.dic objectForKey:@"buyCount"] integerValue]];
        }else{
            cell.detailTextLabel.text=@"0/10";
        }
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
