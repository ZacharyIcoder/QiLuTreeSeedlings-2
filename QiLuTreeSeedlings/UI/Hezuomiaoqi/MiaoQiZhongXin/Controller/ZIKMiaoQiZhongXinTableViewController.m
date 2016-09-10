//
//  ZIKMiaoQiZhongXinTableViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinTableViewController.h"
#import "UIDefines.h"
#import "YYModel.h"//类型转换
#import "HttpClient.h"

#import "ZIKMiaoQiZhongXinModel.h"
#import "ZIKMiaoQiZhongXinHeaderFooterView.h"

#import "ZIKMiaoQiZhongXinBriefSectionTableViewCell.h"
#import "ZIKStationCenterContentTableViewCell.h"
static NSString *SectionHeaderViewIdentifier = @"MiaoQiCenterSectionHeaderViewIdentifier";
#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 240
#define FOOTER_HEIGHT (kHeight-HEADER_HEIGHT-44-44-44-130-60)

@interface ZIKMiaoQiZhongXinTableViewController ()
@property (nonatomic, strong) ZIKMiaoQiZhongXinModel *miaoModel;

@end


@implementation ZIKMiaoQiZhongXinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionHeaderHeight    = HEADER_HEIGHT;
    if (self.view.frame.size.height>480) {
        self.tableView.scrollEnabled  = NO; //设置tableview 不能滚动
    } else {
        self.tableView.scrollEnabled  = YES; //设置tableview 可以滚动
    }
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKMiaoQiZhongXinHeaderFooterView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    [self.tableView setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData {
    [HTTPCLIENT cooperationCompanuCenterWithSuccess:^(id responseObject) {
        //CLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            return ;
        }
        if (self.miaoModel) {
            self.miaoModel = nil;
        }
        NSDictionary *result = responseObject[@"result"];
        self.miaoModel = [ZIKMiaoQiZhongXinModel yy_modelWithDictionary:result];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.tableView.estimatedRowHeight = 85;
        return self.tableView.rowHeight;

    }
    if (indexPath.section == 1) {
        return 130;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZIKMiaoQiZhongXinBriefSectionTableViewCell *briefCell = [ZIKMiaoQiZhongXinBriefSectionTableViewCell cellWithTableView:tableView];
        briefCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return briefCell;
    }
    if (indexPath.section == 1) {
        ZIKStationCenterContentTableViewCell *cell = [ZIKStationCenterContentTableViewCell cellWithTableView:tableView];
//        if (self.masterModel) {
//            [cell configureCell:self.masterModel];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *cellID = @"cellID";
        UITableViewCell *twocell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (twocell == nil) {
            twocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.row == 0) {
            twocell.textLabel.text = @"我的荣誉";
            twocell.textLabel.textColor = [UIColor darkGrayColor];
            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            twocell.imageView.image = [UIImage imageNamed:@"站长中心-我的荣誉"];
        }

        float sw=23/twocell.imageView.image.size.width;
        float sh=25/twocell.imageView.image.size.height;
        twocell.imageView.transform=CGAffineTransformMakeScale(sw,sh);

        twocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//        twocell.selectionStyle = UITableViewCellSelectionStyleNone;

        return twocell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZIKMiaoQiZhongXinHeaderFooterView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
//        if (self.masterModel) {
//            [sectionHeaderView configWithModel:self.masterModel];
//        }
        return sectionHeaderView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = BGColor;
}


@end
