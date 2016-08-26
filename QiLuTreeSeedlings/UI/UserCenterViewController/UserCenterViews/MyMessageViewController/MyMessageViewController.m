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
#import "ZIKBottomDeleteTableViewCell.h"
@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    ZIKBottomDeleteTableViewCell *bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *tapDeleteGR;
  
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic) NSInteger selectNum;
@property (nonatomic,strong)UIView *oldView;
@property (nonatomic,strong)NSArray *throughSelectIndexArr;
@property (nonatomic,strong)  NSMutableArray *CanDelateAry;
@end

@implementation MyMessageViewController
- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"editing"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"通知消息";
    self.dataAry=[NSMutableArray array];
    _removeArray=[NSMutableArray array];
    self.CanDelateAry=[NSMutableArray array];
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
    tapDeleteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    [tableView addGestureRecognizer:tapDeleteGR];
    [tableView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:NULL];
    //底部结算
    bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    bottomcell.frame = CGRectMake(0, kHeight-44, kWidth, 44);
    [self.view addSubview:bottomcell];
    [bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomcell.hidden = YES;
    [bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];

   // Do any additional setup after loading the view.
}

// 显示删除按钮
- (void)deleteCell {
    if (self.dataAry.count == 0) {
        return;
    }
    if (!self.tableView.editing)
    {
        self.CanDelateAry=[NSMutableArray array];
        for (YLDMyMessageModel *model in self.dataAry) {
            if (model.reads==1) {
                [self.CanDelateAry addObject:model];
            }
        }
        self.tableView.editing = YES;
        bottomcell.hidden = NO;
        self.tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64-44);
        [self.tableView removeHeader];//编辑状态取消下拉刷新
        bottomcell.isAllSelect = NO;
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self totalCount];
    }
}

//全选按钮
- (void)selectBtnClick {
    bottomcell.isAllSelect ? (bottomcell.isAllSelect = NO) : (bottomcell.isAllSelect = YES);
    if (bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        for (int i=0; i<self.dataAry.count; i++) {
            YLDMyMessageModel *myModel=self.dataAry[i];
            if(myModel.reads==1)
            {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [_removeArray addObject:myModel];
            }

        }
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        _throughSelectIndexArr = selectedRows;
     
    }
    else if (bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _throughSelectIndexArr=nil;
        for (int i=0; i<self.dataAry.count; i++) {
             [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] animated:YES];
        }
    }
    [self totalCount];
}

- (void)totalCount {
    bottomcell.count = _removeArray.count;
    bottomcell.isAllSelect = NO;
    if (self.CanDelateAry.count==_removeArray.count) {
        bottomcell.isAllSelect = YES;
    }
}

//删除按钮action
- (void)deleteButtonClick {
    if (_removeArray.count<=0) {
        [ToastView showTopToast:@"您未选择删除数据"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除所选内容？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 300;
    alert.delegate = self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 300)//是否退出编辑
    {
        if (buttonIndex == 1) {
            __block NSString *uidString = @"";
            [_removeArray enumerateObjectsUsingBlock:^(YLDMyMessageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",model.uid]];
            }];
            NSString *uids = [uidString substringFromIndex:1];
            [HTTPCLIENT myMessageDeleteWithUid:uids Success:^(id responseObject) {
                if ([responseObject[@"success"] integerValue] == 1) {
                    [ToastView showTopToast:@"删除成功"];

                    [_CanDelateAry removeAllObjects];
                    [_removeArray removeAllObjects];
                    [self totalCount];
                    _throughSelectIndexArr=nil;
                    bottomcell.hidden = YES;
                    self.tableView.editing = NO;
                    self.tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
                    __weak typeof(self) weakSelf = self;//解决循环引用的问题
                    [self.tableView addHeaderWithCallback:^{//添加刷新控件
                        weakSelf.pageCount=1;
                        [weakSelf getDataList];
                    }];
                    [self.tableView headerBeginRefreshing];
                    
                }
                else {
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"editing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] integerValue] == 1) {
            [self.tableView removeGestureRecognizer:tapDeleteGR];
        }
        else {
            [self.tableView addGestureRecognizer:tapDeleteGR];
        }
        // NSLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)getDataList
{
    [HTTPCLIENT messageListWithPage:[NSString stringWithFormat:@"%ld",(long)_pageCount] WithPageSize:@"15" WithReads:@"" Success:^(id responseObject) {
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
                
                if (self.tableView.editing==YES) {
                    if (_throughSelectIndexArr.count > 0) {
                        [_throughSelectIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self.tableView selectRowAtIndexPath:selectIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                        }];
                    }
                    [_CanDelateAry removeAllObjects];
                    for (YLDMyMessageModel *model in self.dataAry) {
                        if (model.reads==1) {
                            [self.CanDelateAry addObject:model];
                        }
                    }
                    [self totalCount];

                }
                
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
    // 判断编辑状态,必须要写
    if (self.tableView.editing)
    {
        
        YLDMyMessageModel *model=self.dataAry[indexPath.section];
        if (model.reads == 0) {
             [ToastView showTopToast:@"未读消息不可删除"];
             [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            // 删除反选数据
            return;
        }
        if (model.reads == 1) {
            // 添加到我们的删除数据源里面
            [_removeArray addObject:model];
            [self totalCount];
             NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
             _throughSelectIndexArr = selectedRows;
        }
        return;
    }
    //非编辑状态下点选
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==_selectNum) {
        _selectNum=-1;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMyMessageModel *model=self.dataAry[indexPath.section];
    if ( self.tableView.editing==YES&&model.reads==1) {
        if ([_removeArray containsObject:model])
        {
           // NSLog(@"........");
            [_removeArray removeObject:model];
        }
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        _throughSelectIndexArr = selectedRows;
        [self totalCount];
    }
}

#pragma mark - 可选方法实现
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

// 设置行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLDMyMessageModel *model=self.dataAry[indexPath.section];
    if (model.reads==0) {
        return NO;
    }else
    {
      return YES;
    }
    
}

// 删除数据风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

-(void)backBtnAction:(UIButton *)sender
{
    if (self.tableView.editing) {
        self.tableView.editing = NO;
        bottomcell.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64, Width, Height-64);
        [_CanDelateAry removeAllObjects];
        [_removeArray removeAllObjects];
        _throughSelectIndexArr=nil;
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.tableView addHeaderWithCallback:^{//添加刷新控件
            _pageCount=1;
            [weakSelf getDataList];
        }];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
