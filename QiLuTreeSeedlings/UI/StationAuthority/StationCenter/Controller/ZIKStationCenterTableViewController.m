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


static NSString *SectionHeaderViewIdentifier = @"StationCenterSectionHeaderViewIdentifier";

@interface ZIKStationCenterTableViewController ()

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 260

@implementation ZIKStationCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionHeaderHeight    = HEADER_HEIGHT;
//    self.tableView.rowHeight = 130;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKStationCenterTableViewHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    [self.tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            honorVC.vctitle = @"我的荣誉";
            [self.navigationController pushViewController:honorVC animated:YES];
        }
    }
}



@end
