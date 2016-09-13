//
//  ZIKMiaoQiDetailTableViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailTableViewController.h"
#import "HttpClient.h"
#import "UIDefines.h"
#import "YYModel.h"//类型转换

#import "ZIKMiaoQiDetailHeaderFooterView.h"
#import "ZIKMiaoQiDetailSecTableViewCell.h"
#import "ZIKMiaoQiDetailModel.h"

#import "ZIKMyHonorViewController.h"
#import "yYLDGZZRongYaoTableCell.h"
#import "ZIKStationShowHonorView.h"
#import "ZIKBaseCertificateAdapter.h"
#import "ZIKCertificateAdapter.h"
static NSString *SectionHeaderViewIdentifier = @"MiaoQiDetailSectionHeaderViewIdentifier";

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 240
//#define FOOTER_HEIGHT (kHeight-HEADER_HEIGHT-44-44-44-130-60-10)
#define FOOTER_HEIGHT 100

@interface ZIKMiaoQiDetailTableViewController ()
@property (nonatomic, strong) ZIKMiaoQiDetailModel *miaoModel;
@property (nonatomic, strong) ZIKStationShowHonorView *showHonorView;

@end

@implementation ZIKMiaoQiDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self initUI];
    [self requestData];
}

- (void)initUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionHeaderHeight    = HEADER_HEIGHT;
    //    if (self.view.frame.size.height>480) {
    //        self.tableView.scrollEnabled  = NO; //设置tableview 不能滚动
    //    } else {
    //        self.tableView.scrollEnabled  = YES; //设置tableview 可以滚动
    //    }
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKMiaoQiDetailHeaderFooterView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    [self.tableView setTableFooterView:view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"ZIKMiaoQiDetailBackHome" object:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)requestData {
    [HTTPCLIENT cooperationCompanyDetailWithUid:self.uid Success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        if (self.miaoModel) {
            self.miaoModel = nil;
        }
        NSDictionary *result = responseObject[@"result"];
        self.miaoModel = [ZIKMiaoQiDetailModel yy_modelWithDictionary:result];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. cooperationCompanyDetailWithUid
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 10.0f;
    }
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
//        self.tableView.estimatedRowHeight = 85;
//        return self.tableView.rowHeight;
        return 186;

    }
    if (indexPath.section == 1) {
        if (self.miaoModel.honor.count<=0) {
            return 60;
        }
        return 170;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return FOOTER_HEIGHT;
    }
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZIKMiaoQiDetailSecTableViewCell *briefCell = [ZIKMiaoQiDetailSecTableViewCell cellWithTableView:tableView];
        if (self.miaoModel) {
            [briefCell configureCell:_miaoModel];
        }
//        briefCell.indexPath = indexPath;
//        //按钮点击展开隐藏
//
//        __weak typeof(self) weakSelf = self;//解决循环引用的问题
//
//        briefCell.openButtonBlock = ^(NSIndexPath *indexPath){
//            //            weakSelf.miaoModel.isShow = !weakSelf.miaoModel.isShow;
//            //            //一个section刷新
//            //            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//            //            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            //            [tableView reloadData];
//            weakSelf.miaoModel.isShow = !weakSelf.miaoModel.isShow;
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        };
        briefCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return briefCell;
    }
    if(indexPath.section==1)
    {
        yYLDGZZRongYaoTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yYLDGZZRongYaoTableCell"];
        if (!cell) {
            cell =[yYLDGZZRongYaoTableCell yldGZZRongYaoTableCell];
            cell.dataAry=self.miaoModel.honor;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.allBtn addTarget:self action:@selector(allRongYuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell showImageActionBlock:^(ZIKStationHonorListModel *model) {
                if (!self.showHonorView) {
                    self.showHonorView = [ZIKStationShowHonorView instanceShowHonorView];
                    self.showHonorView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
                }
                ZIKBaseCertificateAdapter *modelAdapter = [[ZIKCertificateAdapter alloc] initWithData:model];
                [self.showHonorView loadData:modelAdapter];


                [self.view addSubview:self.showHonorView];
                [UIView animateWithDuration:.3 animations:^{
                    self.showHonorView.frame = CGRectMake(0, 0, kWidth, kHeight);
                }];
            }];
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZIKMiaoQiDetailHeaderFooterView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        if (self.miaoModel) {
            [sectionHeaderView configWithModel:self.miaoModel];
        }
        return sectionHeaderView;
    }
    return nil;
}

//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
//    view.tintColor = BGColor;
//}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKMiaoQiDetailBackHome" object:nil];
}

-(void)allRongYuBtnAction:(UIButton *)sender
{
    ZIKMyHonorViewController *zsdasda=[[ZIKMyHonorViewController alloc]init];
    zsdasda.type = TypeMiaoQiHonor;
//    zsdasda.workstationUid = self.miaoModel.uid;
    zsdasda.memberUid = self.miaoModel.memberUid;
    [self.navigationController pushViewController:zsdasda animated:YES];
}


@end
