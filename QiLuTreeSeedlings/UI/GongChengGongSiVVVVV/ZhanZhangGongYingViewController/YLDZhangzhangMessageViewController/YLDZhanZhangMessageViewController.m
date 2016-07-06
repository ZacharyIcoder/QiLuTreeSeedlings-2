//
//  YLDZhanZhangMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZhanZhangMessageViewController.h"
#import "ZIKMyHonorViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "YLDGongZuoZhanMessageCell.h"
#import "YLDZhanZhangMessageCell.h"
#import "YLDGongZuoZhanJianJieCell.h"
#import "yYLDGZZRongYaoTableCell.h"
@interface YLDZhanZhangMessageViewController ()<UITableViewDelegate,UITableViewDataSource,YLDZhanZhangMessageCellDelegate>
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation YLDZhanZhangMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *talbeView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    talbeView.delegate=self;
    talbeView.dataSource=self;
    talbeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView=talbeView;
    [self.view addSubview:talbeView];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 200;
    }
    if (indexPath.section==1) {
        return 80;
    }
    if (indexPath.section==2) {
        return 120;
    }
    if (indexPath.section==3) {
        return 150;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==0) {
        return 0.01;
    }else
    {
        return 10;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        YLDZhanZhangMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDZhanZhangMessageCell"];
        if (!cell) {
            cell=[YLDZhanZhangMessageCell yldZhanZhangMessageCell];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    if (indexPath.section==1) {
        
        YLDGongZuoZhanJianJieCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanJianJieCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanJianJieCell yldGongZuoZhanJianJieCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    if (indexPath.section==2) {
        
        YLDGongZuoZhanMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongZuoZhanMessageCell"];
        if (!cell) {
            cell=[YLDGongZuoZhanMessageCell yldGongZuoZhanMessageCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    if(indexPath.section==3)
    {
        yYLDGZZRongYaoTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDGZZRongYaoTableCell"];
        if (!cell) {
           cell =[yYLDGZZRongYaoTableCell yldGZZRongYaoTableCell];
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.allBtn addTarget:self action:@selector(allRongYuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)allRongYuBtnAction:(UIButton *)sender
{
    ZIKMyHonorViewController *zsdasda=[[ZIKMyHonorViewController alloc]init];
    zsdasda.type = TypeQualification;
    [self.navigationController pushViewController:zsdasda animated:YES];
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
