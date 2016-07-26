//
//  YLDShopBaseInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopBaseInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGCZXInfoTableViewCell.h"
#import "YLDGCZXTouxiangTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "YLDShopNameViewController.h"
@interface YLDShopBaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)YLDGCZXTouxiangTableViewCell *touxiangCell;
@property (nonatomic,copy) NSDictionary *dic;
@end

@implementation YLDShopBaseInfoViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [HTTPCLIENT getMyShopBaseMessageSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.dic=[[responseObject objectForKey:@"result"] objectForKey:@"shopinfo"];
            [self.tableView reloadData];
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"基本信息";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [tableView setBackgroundColor:BGColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    ShowActionV();
    // Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        YLDShopNameViewController *vc=[[YLDShopNameViewController alloc]initWithMessage:[self.dic objectForKey:@"shopName"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 60;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        YLDGCZXTouxiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXTouxiangTableViewCell"];
    
        if (!cell) {
            cell=[YLDGCZXTouxiangTableViewCell yldGCZXTouxiangTableViewCell];
            [cell.imagev setImageWithURL:[NSURL URLWithString:APPDELEGATE.GCGSModel.attachment] placeholderImage:[UIImage imageNamed:@"UserImage"]];
        }
        cell.titleLab.text=@"店铺头像";
        self.touxiangCell=cell;
        return cell;
    }else{
        YLDGCZXInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXInfoTableViewCell"];
        if (!cell) {
            cell=[YLDGCZXInfoTableViewCell yldGCZXInfoTableViewCell];
        }
        if (indexPath.row==1) {
            cell.titleLab.text=@"店铺名称";
            cell.NameLab.text=[self.dic objectForKey:@"shopName"];
            
        }
        if (indexPath.row==2) {
            cell.titleLab.text=@"店铺简介";
            cell.NameLab.text=[self.dic objectForKey:@"brief"];
            
        }
        if (indexPath.row==3) {
            cell.titleLab.text=@"联系人";
            cell.NameLab.text=[self.dic objectForKey:@"chargelPerson"];
//            cell.NameLab.text=APPDELEGATE.GCGSModel.address;
            
        }
        if (indexPath.row==4) {
            cell.titleLab.text=@"联系方式";
           cell.NameLab.text=[self.dic objectForKey:@"phone"];
            
        }
        if (indexPath.row==5) {
            cell.titleLab.text=@"所在地";
            cell.NameLab.text=[self.dic objectForKey:@"areaAddress"];
            //            cell.NameLab.text=APPDELEGATE.GCGSModel.brief;
            
        }
        if (indexPath.row==5) {
            cell.lineV.hidden=YES;
        }else
        {
            cell.lineV.hidden=NO;
            if (indexPath.row==2) {
                CGRect frame=cell.lineV.frame;
                frame.size.height=10;
                frame.origin.x=0;
                frame.size.width=kWidth;
                cell.lineV.frame=frame;
                [cell.lineV setBackgroundColor:BGColor];
                
            }
        }
        return cell;
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
