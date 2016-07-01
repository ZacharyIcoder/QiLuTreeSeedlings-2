//
//  ZIKStationCenterInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterInfoViewController.h"
#import "ZIKStationChangeInfoViewController.h"
#import "YYModel.h"//类型转换

@interface ZIKStationCenterInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //UIImageView    *_globalHeadImageView; //个人头像
    UIImage        *_globalHeadImage;
    UIImageView    *cellHeadImageView;
    UILabel        *cellNameLabel;
    UILabel        *cellPhoneLabel;
}
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTableView;
@end
/**/

@implementation ZIKStationCenterInfoViewController
@synthesize titlesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"站长信息";
    titlesArray = @[@"我的头像",@"姓名",@"电话",@"自我介绍"];

    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 44*4) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate   = self;
    [self.view addSubview:tableview];
    tableview.scrollEnabled = NO;
    self.myTableView = tableview;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *infoCellId = @"infoCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCellId];
    }
    cell.textLabel.text = titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = DarkTitleColor;
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = self.masterModel.chargelPerson;
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.masterModel.phone;
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = self.masterModel.brief;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKStationChangeInfoViewController *changeInfoVC = [[ZIKStationChangeInfoViewController alloc] initWithNibName:@"ZIKStationChangeInfoViewController" bundle:nil];
    NSString *placeholderStr = [NSString stringWithFormat:@"请输入%@",titlesArray[indexPath.row]];
    changeInfoVC.titleString = titlesArray[indexPath.row];
    changeInfoVC.placeholderString = placeholderStr;
    [self.navigationController pushViewController:changeInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
- (void)requestData {
    [HTTPCLIENT stationMasterSuccess:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        if (self.masterModel) {
            self.masterModel = nil;
        }
        NSDictionary *result = responseObject[@"result"];
        NSDictionary *masterInfo = result[@"masterInfo"];
        self.masterModel = [MasterInfoModel yy_modelWithDictionary:masterInfo];
        [self.myTableView reloadData];

    } failure:^(NSError *error) {
        ;
    }];
}

@end
