//
//  ZIKStationCenterTableViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterTableViewController.h"
#import "ZIKStationCenterTableViewHeaderView.h"
#import "ZIKStationCenterContentTableViewCell.h"
#import "UIDefines.h"
#import "ZIKMyHonorViewController.h"
#import "MasterInfoModel.h"
#import "YYModel.h"//类型转换
#import "ZIKStationCenterInfoViewController.h"
#import "ZIKMyTeamViewController.h"//我的团队
static NSString *SectionHeaderViewIdentifier = @"StationCenterSectionHeaderViewIdentifier";

@interface ZIKStationCenterTableViewController ()
@property (nonatomic, strong) MasterInfoModel *masterModel;
@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 260

@implementation ZIKStationCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     //[self requestData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionHeaderHeight    = HEADER_HEIGHT;
//    self.tableView.rowHeight = 130;
    self.tableView.scrollEnabled  = NO; //设置tableview 不能滚动

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKStationCenterTableViewHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    [self.tableView setTableFooterView:view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChangeMasterInfo) name:@"ZIKChangeMasterInfo" object:nil];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZIKChangeMasterInfo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)pushChangeMasterInfo {
    ZIKStationCenterInfoViewController *changeInfoVC = [[ZIKStationCenterInfoViewController alloc] init];
    changeInfoVC.hidesBottomBarWhenPushed = YES;
    changeInfoVC.masterModel = self.masterModel;
    [self.navigationController pushViewController:changeInfoVC animated:YES];
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
       [self.tableView reloadData];

   } failure:^(NSError *error) {
       ;
   }];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0f;
    }
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZIKStationCenterContentTableViewCell *cell = [ZIKStationCenterContentTableViewCell cellWithTableView:tableView];
        if (self.masterModel) {
            [cell configureCell:self.masterModel];
        }
        return cell;
    } else if (indexPath.section == 1) {
      static NSString *cellID = @"cellID";
        UITableViewCell *twocell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (twocell == nil) {
            twocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.row == 0) {
            twocell.textLabel.text = @"我的荣誉";
            twocell.textLabel.textColor = [UIColor darkGrayColor];
            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            twocell.imageView.image = [UIImage imageNamed:@"消费记录40x40"];
        } else if (indexPath.row == 1) {
            twocell.textLabel.text = @"我的团队";
            twocell.textLabel.textColor = [UIColor darkGrayColor];
            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            twocell.imageView.image = [UIImage imageNamed:@"消费记录40x40"];
        }

        float sw=23/twocell.imageView.image.size.width;
        float sh=25/twocell.imageView.image.size.height;
        twocell.imageView.transform=CGAffineTransformMakeScale(sw,sh);

        twocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        twocell.selectionStyle = UITableViewCellSelectionStyleNone;

        return twocell;
    }
        return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZIKStationCenterTableViewHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        if (self.masterModel) {
            [sectionHeaderView configWithModel:self.masterModel];

        }
        return sectionHeaderView;
    }
    return nil;
 }

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ZIKMyHonorViewController *honorVC = [[ZIKMyHonorViewController alloc] initWithNibName:@"ZIKMyHonorViewController" bundle:nil];
            honorVC.hidesBottomBarWhenPushed  = YES;
            honorVC.type = TypeHonor;
            honorVC.workstationUid = self.masterModel.uid;
            [self.navigationController pushViewController:honorVC animated:YES];
        } else if (indexPath.row == 1) {
            ZIKMyTeamViewController *teamVC = [[ZIKMyTeamViewController  alloc] initWithNibName:@"ZIKMyTeamViewController" bundle:nil];
            teamVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamVC animated:YES];
        }
    }
}



@end
