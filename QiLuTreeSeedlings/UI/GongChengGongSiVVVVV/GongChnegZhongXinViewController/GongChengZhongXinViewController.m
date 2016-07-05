//
//  GongChengZhongXinViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GongChengZhongXinViewController.h"
#import "YLDGongChengZhongXinBigCell.h"
#import "YLDFaBuGongChengDingDanViewController.h"
#import "yYLDCompanyMessageCell.h"
#import "YLDGCZXzizhiCell.h"
#import "UIDefines.h"
#import "ZIKMyHonorViewController.h"
#import "YLDGongChengAnLiViewController.h"
#import "UIDefines.h"
@interface GongChengZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *talbeView;
@end

@implementation GongChengZhongXinViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *talbeView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    talbeView.delegate=self;
    talbeView.dataSource=self;
    talbeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.talbeView=talbeView;
    [self.view addSubview:talbeView];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabubtnAction) name:@"YLDGONGChengFabuAction" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 200;
        }
        if (indexPath.row==1) {
            return 120;
        }
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            YLDGongChengZhongXinBigCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGongChengZhongXinBigCell"];
            if (!cell) {
                cell=[YLDGongChengZhongXinBigCell yldGongChengZhongXinBigCell];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.model=APPDELEGATE.GCGSModel;
            return cell;
            
        }
        if (indexPath.row==1) {
            yYLDCompanyMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDCompanyMessageCell"];
            if (!cell) {
                cell=[yYLDCompanyMessageCell yyldCompanyMessageCell];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.model=APPDELEGATE.GCGSModel;
            return cell;
            
        }
    }
    if(indexPath.section==1)
    {
        YLDGCZXzizhiCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDGCZXzizhiCell"];
        if (!cell) {
            cell=[YLDGCZXzizhiCell yldGCZXzizhiCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==0) {
            [cell setMessageWithImageName:@"GCZXgongsizizhi.png" andTitle:@"公司资质"];
        }
        if (indexPath.row==1) {
            [cell setMessageWithImageName:@"GCZXgongsianli.png" andTitle:@"公司案例"];
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            ZIKMyHonorViewController *norViewController=[[ZIKMyHonorViewController alloc] init];
        norViewController.vctitle=@"公司资质";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
            [self.navigationController pushViewController:norViewController animated:YES];
        }
        if (indexPath.row==1) {
            
            YLDGongChengAnLiViewController *gChengController=[[YLDGongChengAnLiViewController alloc] init];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
            [self.navigationController pushViewController:gChengController animated:YES];
        }
    }
}
-(void)fabubtnAction
{
    if(self.tabBarController.selectedIndex==3)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengHidenTabBar" object:nil];
        YLDFaBuGongChengDingDanViewController *fabuVC=[[YLDFaBuGongChengDingDanViewController alloc]init];
        [self.navigationController pushViewController:fabuVC animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YLDGongchengshowTabBar" object:nil];
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
