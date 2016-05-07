//
//  MyMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyMessageViewController.h"
#import "UIDefines.h"
#import "MJRefresh.h"
#import "YLDMyMessageModel.h"
#import "YLDMyMessageTableViewCell.h"
@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic) NSInteger selectNum;
@property (nonatomic,strong)UIView *oldView;
@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"通知消息";
    self.dataAry=[NSMutableArray array];
    _pageCount=1;
    _selectNum=-1;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    __weak typeof(self) weakSelf=self;
    [tableView addHeaderWithCallback:^{
        weakSelf.pageCount=1;
        weakSelf.selectNum=-1;
        [weakSelf getDataList];
    }];
    [tableView addFooterWithCallback:^{
        weakSelf.pageCount+=1;
        [weakSelf getDataList];
    }];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView headerBeginRefreshing];
   // Do any additional setup after loading the view.
}
-(void)getDataList
{
    [HTTPCLIENT messageListWithPage:[NSString stringWithFormat:@"%ld",_pageCount] WithPageSize:@"15" WithReads:@"" Success:^(id responseObject) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (_pageCount==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"recordList"];
            NSArray *aryzz=[YLDMyMessageModel creatModelAryWithAry:ary];
            YLDMyMessageModel *model1 = [self.dataAry lastObject];
            YLDMyMessageModel *model2=[aryzz lastObject];
            if (ary.count==0&&self.dataAry.count>0) {
                [ToastView showTopToast:@"已无更多信息"];
                _pageCount--;
                if (_pageCount<1) {
                    _pageCount=1;
                }
                
            }
            if ([model1.uid isEqualToString:model2.uid]) {
                [ToastView showTopToast:@"已无更多信息"];
                _pageCount--;
                if (_pageCount<1) {
                    _pageCount=1;
                }
            }else
            {
                [self.dataAry addObjectsFromArray:aryzz];
                [self.tableView reloadData];
                
            }
            
        }
        
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDMyMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDMyMessageTableViewCell"];
    if (!cell) {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"YLDMyMessageTableViewCell" owner:self options:nil] lastObject];
    }
    YLDMyMessageModel *model=self.dataAry[indexPath.section];
    cell.model=model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.selectNum) {
        YLDMyMessageModel *model=self.dataAry[section];
        CGFloat height = [self getHeightWithContent:model.message width:kWidth-20 font:14];
        return height+10;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=nil;
    if (section==_selectNum) {
        YLDMyMessageModel *model=self.dataAry[section];
        CGFloat height = [self getHeightWithContent:model.message width:kWidth-20 font:14];
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, height+10)];
        UIImageView *iamgev=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, kWidth-20, 0.5)];
        [view addSubview:iamgev];
        [iamgev setBackgroundColor:kLineColor];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWidth-20, height)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setTextColor:detialLabColor];
        lab.text=model.message;
        lab.numberOfLines=0;
        [view addSubview:lab];
        [view setBackgroundColor:[UIColor whiteColor]];
        if (self.oldView) {
            [self.oldView removeFromSuperview];
            self.oldView=view;
        }else{
            self.oldView=view;
        }
    }
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==_selectNum) {
        return;
    }
    YLDMyMessageModel *model=self.dataAry[indexPath.section];
    if (model.reads==0) {
        model.reads=1;
        [HTTPCLIENT myMessageReadingWithUid:model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    _selectNum=indexPath.section;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
  
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
