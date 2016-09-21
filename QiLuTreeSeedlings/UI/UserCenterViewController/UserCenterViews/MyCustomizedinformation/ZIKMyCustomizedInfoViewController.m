//
//  ZIKMyCustomizedInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyCustomizedInfoViewController.h"
#import "ZIKCustomizedInfoListViewController.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "ZIKCustomizedInfoListModel.h"
#import "ZIKCustomizedInfoListTableViewCell.h"
#import "BuyDetialInfoViewController.h"
#import "YLDCustomUnReadTableViewCell.h"
#import "ZIKHaveReadInfoViewController.h"
#import "ZIKBottomDeleteTableViewCell.h"


@interface ZIKMyCustomizedInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, assign) NSInteger      page;//页数从1开始
@property (nonatomic, strong) NSMutableArray *customizedInfoMArr;//定制信息数组
@property (nonatomic ,strong) NSMutableArray *custominzedZuAryy;
@property (nonatomic, strong) UITableView    *myCustomizedInfoTableView;//我的定制信息列表
@end

@implementation ZIKMyCustomizedInfoViewController
{
    UIView *_emptyUI;
    ZIKBottomDeleteTableViewCell *_bottomcell;
    NSMutableArray *_removeArray;
    UILongPressGestureRecognizer *_longPressGr;
    NSArray *_deleteIndexArr;//选中的删除index
}

#pragma mark - 返回箭头按钮点击事件
-(void)backBtnAction:(UIButton *)sender
{
    if (self.myCustomizedInfoTableView.editing) {
        self.myCustomizedInfoTableView.editing = NO;
        if (_removeArray.count > 0) {//选中的删除model清空
            [_removeArray removeAllObjects];
        }
        if (_deleteIndexArr.count > 0) {//选中的删除cell 的 index清空
            _deleteIndexArr = nil;
        }
        _bottomcell.hidden = YES;
        _bottomcell.count = 0;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, self.myCustomizedInfoTableView.frame.origin.y, Width, Height-64);//更改tableview 的frame
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        [self.myCustomizedInfoTableView addHeaderWithCallback:^{//添加刷新控件
            [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        }];
    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myCustomizedInfoTableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
    // Do any additional setup after loading the view.
    [self initData];
    [self configNav];
    [self initUI];
    [self requestData];
}

- (void)configNav {
    if (self.infoType == InfoTypeMy) {
        self.vcTitle = @"定制信息";
        self.rightBarBtnTitleString = @"定制";
        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        self.rightBarBtnBlock = ^{
            ZIKCustomizedInfoListViewController *listVC = [[ZIKCustomizedInfoListViewController alloc] init];
            [weakSelf.navigationController pushViewController:listVC animated:YES];
        };
    } else if (self.infoType == InfoTypeStation) {
        self.vcTitle = @"工程采购推送记录";
        self.rightBarBtnTitleString = @"";

    }
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;//解决循环引用的问题
    [self.myCustomizedInfoTableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    [self.myCustomizedInfoTableView headerBeginRefreshing];
}

- (void)initUI {
    self.myCustomizedInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStyleGrouped];
    self.myCustomizedInfoTableView.delegate   = self;
    self.myCustomizedInfoTableView.dataSource = self;
    [self.view addSubview:self.myCustomizedInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.myCustomizedInfoTableView];

    //添加长按手势
    _longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR)];
    [self.myCustomizedInfoTableView addGestureRecognizer:_longPressGr];

    //底部删除view
    _bottomcell = [ZIKBottomDeleteTableViewCell cellWithTableView:nil];
    _bottomcell.count = 0;
    _bottomcell.frame = CGRectMake(0, Height-BOTTOM_DELETE_CELL_HEIGHT, Width, BOTTOM_DELETE_CELL_HEIGHT);
    [self.view addSubview:_bottomcell];
    [_bottomcell.seleteImageButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomcell.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomcell.hidden = YES;

}

- (void)tapGR {
    if (!self.myCustomizedInfoTableView.editing) {
        [self.myCustomizedInfoTableView removeHeader];//编辑状态取消下拉刷新
        self.myCustomizedInfoTableView.editing = YES;
        _bottomcell.hidden = NO;
        _bottomcell.isAllSelect = NO;
        self.myCustomizedInfoTableView.frame = CGRectMake(0, self.myCustomizedInfoTableView.frame.origin.y, Width, Height-64-BOTTOM_DELETE_CELL_HEIGHT);
    }
}

- (void)selectBtnClick {
    _bottomcell.isAllSelect = !_bottomcell.isAllSelect;
    if (_bottomcell.isAllSelect) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        [self.custominzedZuAryy enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            [_removeArray addObject:dic];
        }];
        NSMutableArray *tempMArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.custominzedZuAryy.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i+1];
            [self.myCustomizedInfoTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tempMArr addObject:[NSIndexPath indexPathForRow:0 inSection:i+1]];
        }
        _bottomcell.count = _removeArray.count;
        _deleteIndexArr = (NSArray *)tempMArr;
    }
    else if (_bottomcell.isAllSelect == NO) {
        if (_removeArray.count > 0) {
            [_removeArray removeAllObjects];
        }
        _bottomcell.count = 0;
        _deleteIndexArr = nil;
        for (NSInteger i = 0; i < self.custominzedZuAryy.count; i++) {
            [self.myCustomizedInfoTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i+1] animated:YES];
        }
    }
}

- (void)deleteButtonClick {
    if (_removeArray.count  == 0) {
        [ToastView showToast:@"请选择要删除的选项" withOriginY:200 withSuperView:self.view];
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
            __weak typeof(_removeArray) removeArr = _removeArray;
            __weak __typeof(self) blockSelf = self;

            __block NSString *uidString = @"";
            [_removeArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                uidString = [uidString stringByAppendingString:[NSString stringWithFormat:@",%@",dic[@"uid"]]];
            }];
            NSString *uids = [uidString substringFromIndex:1];
            NSInteger customizedType = (NSInteger)self.infoType;
            [HTTPCLIENT deleteprorecordWithIds:uids infoType:customizedType Success:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([responseObject[@"success"] integerValue] == 1) {

                    [removeArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([blockSelf.custominzedZuAryy containsObject:dic]) {
                            [blockSelf.custominzedZuAryy removeObject:dic];
                        }
                    }];
                    [blockSelf.myCustomizedInfoTableView reloadData];
                    if (blockSelf.custominzedZuAryy.count == 0) {
                        _bottomcell.hidden = YES;
                        self.myCustomizedInfoTableView.editing = NO;
                        self.myCustomizedInfoTableView.frame = CGRectMake(0, self.myCustomizedInfoTableView.frame.origin.y, Width, Height-64);
                        [self requestData];
                    }
                    if (_removeArray.count > 0) {
                        [_removeArray removeAllObjects];
                    }
                    if (_deleteIndexArr.count > 0) {
                        _deleteIndexArr = nil;
                    }
                    _bottomcell.count = 0;
                    _bottomcell.hidden = YES;
                    //[self updateBottomDeleteCellView];
                    [ToastView showToast:@"删除成功" withOriginY:200 withSuperView:self.view];
                    _bottomcell.hidden = YES;
                    self.myCustomizedInfoTableView.editing = NO;
                    self.myCustomizedInfoTableView.frame = CGRectMake(0, self.myCustomizedInfoTableView.frame.origin.y, Width, Height-64);//更改tableview 的frame
                    __weak typeof(self) weakSelf = self;//解决循环引用的问题
                    [self.myCustomizedInfoTableView addHeaderWithCallback:^{//添加刷新控件
                        [weakSelf requestSellList:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
                    }];
                } else {
                    [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"error"]] withOriginY:200 withSuperView:self.view];
                }
            } failure:^(NSError *error) {
            }];
        }
    }
}

- (void)requestSellList:(NSString *)page {

    RemoveActionV();

    [self.myCustomizedInfoTableView headerEndRefreshing];
    ShowActionV();
    HttpClient *httpClient = [HttpClient sharedClient];
    NSInteger customizedType = (NSInteger)self.infoType;
    [httpClient customizationUnReadWithPageSize:@"15" PageNumber:page infoType:customizedType Success:^(id responseObject) {
         RemoveActionV();
        NSDictionary *dic = [responseObject objectForKey:@"result"];
        NSArray *array = dic[@"recordList"];
        NSArray *array2=dic[@"typeList"];
        if (array.count == 0 && self.page == 1&&array2.count==0) {
            [self.customizedInfoMArr removeAllObjects];
            [self.custominzedZuAryy removeAllObjects];
            [self.myCustomizedInfoTableView footerEndRefreshing];
            self.myCustomizedInfoTableView.hidden = YES;
            [self createEmptyUI];
            return ;
        } else if (array.count == 0 && self.page > 1) {
            self.myCustomizedInfoTableView.hidden = NO;
            _emptyUI.hidden = YES;
            self.page--;
            [self.myCustomizedInfoTableView footerEndRefreshing];
            //没有更多数据了
            [ToastView showToast:@"已无更多信息" withOriginY:Width/2 withSuperView:self.view];
            return;
        } else {
            self.myCustomizedInfoTableView.hidden = NO;
            _emptyUI.hidden = YES;
            if (self.page == 1) {
                [self.customizedInfoMArr removeAllObjects];
            }
            [self.custominzedZuAryy removeAllObjects];
            [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ZIKCustomizedInfoListModel *model = [ZIKCustomizedInfoListModel yy_modelWithDictionary:dic];
                [self.customizedInfoMArr addObject:model];
            }];
            [self.custominzedZuAryy addObjectsFromArray:array2];
            [self.myCustomizedInfoTableView reloadData];
            //[self.myCustomizedInfoTableView footerEndRefreshing];
            if (self.myCustomizedInfoTableView.editing) {
                if (_deleteIndexArr.count > 0) {
                    [_deleteIndexArr enumerateObjectsUsingBlock:^(NSIndexPath *selectDeleteIndex, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.myCustomizedInfoTableView selectRowAtIndexPath:selectDeleteIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
                    }];
                }
                //[self updateBottomDeleteCellView];
            }
            [self.myCustomizedInfoTableView footerEndRefreshing];
        }

    } failure:^(NSError *error) {
          RemoveActionV();
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (self.customizedInfoMArr.count>0) {
            return 64;
        }else
        {
            return 0.001;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.01f;
    }else
    {
       return 8;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.customizedInfoMArr.count;
    }else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return 1+self.custominzedZuAryy.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *kZIKCustomizedInfoListTableViewCellID = @"YLDCustomUnReadTableViewCell";
        YLDCustomUnReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKCustomizedInfoListTableViewCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YLDCustomUnReadTableViewCell" owner:self options:nil] lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.customizedInfoMArr.count > 0) {
            cell.model = self.customizedInfoMArr[indexPath.row];
        }
          return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xxxxxx"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxxxxx"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
         NSDictionary *dic=self.custominzedZuAryy[indexPath.section-1];
        cell.textLabel.text=[dic objectForKey:@"name"];
        cell.textLabel.textColor = titleLabColor;
        return cell;
    }
 
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        ZIKCustomizedInfoListModel *model = self.customizedInfoMArr[indexPath.row];
        if (self.infoType == InfoTypeMy) {
            BuyDetialInfoViewController *viewC = [[BuyDetialInfoViewController alloc]initWithDingzhiModel:model];
            [self.navigationController pushViewController:viewC animated:YES];
        } else if (self.infoType == InfoTypeStation) {
            BuyDetialInfoViewController *viewC = [[BuyDetialInfoViewController alloc]initWithCaiGouModel:model];
//            viewC.isCaiGou = YES;
            [self.navigationController pushViewController:viewC animated:YES];
        }

    }else{
        if (tableView.editing) {
            NSDictionary *dic = self.custominzedZuAryy[indexPath.section-1];
            [_removeArray addObject:dic];
            _bottomcell.count = _removeArray.count;
            NSArray *selectedRows = [self.myCustomizedInfoTableView indexPathsForSelectedRows];
            _deleteIndexArr = selectedRows;
            [self updateBottomDeleteCellView];
            return;
        }
        else {
            NSDictionary *dic=self.custominzedZuAryy[indexPath.section-1];
            // NSLog(@"%@",dic);
            ZIKHaveReadInfoViewController *hrVC = [[ZIKHaveReadInfoViewController alloc] init];
            hrVC.uidStr = dic[@"uid"];
            hrVC.name   = dic[@"name"];
            hrVC.infoType = self.infoType;
            [self.navigationController pushViewController:hrVC animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *model = [self.custominzedZuAryy objectAtIndex:indexPath.section-1];

    if ([_removeArray containsObject:model]) {//删除反选数据
        [_removeArray removeObject:model];
    }
    NSArray *selectedRows = [self.myCustomizedInfoTableView indexPathsForSelectedRows];
    _deleteIndexArr = selectedRows;
    _bottomcell.count = _removeArray.count;
    [self updateBottomDeleteCellView];
}

#pragma mark - 更改底部删除视图( 过期编辑状态下  是否全选)
- (void)updateBottomDeleteCellView {
    (_deleteIndexArr.count == self.custominzedZuAryy.count) ? (_bottomcell.isAllSelect = YES) : (_bottomcell.isAllSelect = NO);
}

#pragma mark - 可选实现的协议方法
// 删除时的提示文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 开启某行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  NO;
    }
    return YES;
}

// 设置cell行编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;

}

// 编辑时触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
}

- (void)createEmptyUI {
    if (!_emptyUI) {
        _emptyUI                 = [[UIView alloc] init];
        _emptyUI.frame           = CGRectMake(0, 64, Width, 260);
        _emptyUI.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_emptyUI];
        UIImageView *imageView  = [[UIImageView alloc] init];
        imageView.frame         = CGRectMake(Width/2-50, 30, 100, 100);
        imageView.image         = [UIImage imageNamed:@"图片1"];
        [_emptyUI addSubview:imageView];

        UILabel *label1         = [[UILabel alloc] init];
        label1.frame            = CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, Width, 25);
        label1.text             = @"空空如也~~";
        label1.textAlignment    = NSTextAlignmentCenter;
        label1.textColor        = detialLabColor;
        [_emptyUI addSubview:label1];

        UILabel *label2         = [[UILabel alloc] init];
        label2.frame            = CGRectMake(0, CGRectGetMaxY(label1.frame), Width, label1.frame.size.height);
        label2.text             = @"还没有收到任何定制信息";
        label2.textColor        = detialLabColor;
        label2.textAlignment    = NSTextAlignmentCenter;
        [_emptyUI addSubview:label2];
        
    }
    
}

- (void)initData {
    if (!self.infoType) {
        self.infoType = InfoTypeMy;
    }
    self.page               = 1;
    self.customizedInfoMArr = [NSMutableArray array];
    self.custominzedZuAryy  = [NSMutableArray array];
    _removeArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
