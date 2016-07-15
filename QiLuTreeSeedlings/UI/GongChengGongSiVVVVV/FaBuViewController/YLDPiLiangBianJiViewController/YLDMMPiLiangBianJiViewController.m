//
//  YLDMMPiLiangBianJiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMMPiLiangBianJiViewController.h"
#import "YLDMMPiLiangBianJiCell.h"
#import "UIDefines.h"
@interface YLDMMPiLiangBianJiViewController ()<UITableViewDelegate,UITableViewDataSource,YLDMMPiLiangBianJiCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *cellAry;
@end

@implementation YLDMMPiLiangBianJiViewController
-(id)initWithDataAry:(NSMutableArray *)dataAry
{
    self=[super init];
    if (self) {
        self.dataAry =[NSMutableArray arrayWithArray:dataAry];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"订单发布";
    self.cellAry=[NSMutableArray array];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    UIButton *finishBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 24, 60, 40)];
    [finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.navBackView addSubview:finishBtn];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)finishBtnAction
{
    for (int i=0; i<self.cellAry.count; i++) {
        YLDMMPiLiangBianJiCell *cell=self.cellAry[i];
        if (![cell checkChangeMessage]) {
            return;
        }
    }
    for (int i=0; i<self.cellAry.count; i++) {
        YLDMMPiLiangBianJiCell *cell=self.cellAry[i];
        [cell getChangeMessage];
    }
    if ([self.delegate respondsToSelector:@selector(finishActionWithAry:)]) {
        [self.delegate finishActionWithAry:self.dataAry];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteWithSelf:(YLDMMPiLiangBianJiCell *)cell andRow:(NSInteger)row andDic:(NSMutableDictionary *)dic{
//    [self.cellAry removeObjectAtIndex:row];
    [self.dataAry removeObjectAtIndex:row];
    [self.tableView reloadData];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IDStr=[NSString stringWithFormat:@"YLDMMPiLiangBianJiCell%ld",indexPath.row];
    YLDMMPiLiangBianJiCell *cell=[tableView dequeueReusableCellWithIdentifier:IDStr];
    if (!cell) {
        cell=[[YLDMMPiLiangBianJiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDStr];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.cellAry addObject:cell];
    }
    NSMutableDictionary *dic=self.dataAry[indexPath.row];
    cell.messageDic=dic;
    cell.deleteBtn.tag=indexPath.row;
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
