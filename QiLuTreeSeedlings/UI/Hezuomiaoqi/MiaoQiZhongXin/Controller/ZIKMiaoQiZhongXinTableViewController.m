//
//  ZIKMiaoQiZhongXinTableViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinTableViewController.h"
#import "UIDefines.h"

#import "ZIKMiaoQiZhongXinModel.h"

static NSString *SectionHeaderViewIdentifier = @"StationCenterSectionHeaderViewIdentifier";
#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define HEADER_HEIGHT 240
#define FOOTER_HEIGHT (kHeight-HEADER_HEIGHT-44-44-44-44-130-60)

@interface ZIKMiaoQiZhongXinTableViewController ()
@property (nonatomic, strong) ZIKMiaoQiZhongXinModel *miaoModel;

@end


@implementation ZIKMiaoQiZhongXinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return FOOTER_HEIGHT;
    }
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        ZIKStationCenterContentTableViewCell *cell = [ZIKStationCenterContentTableViewCell cellWithTableView:tableView];
//        if (self.masterModel) {
//            [cell configureCell:self.masterModel];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
    }
//    else if (indexPath.section == 1) {
//        static NSString *cellID = @"cellID";
//        UITableViewCell *twocell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (twocell == nil) {
//            twocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        if (indexPath.row == 0) {
//            twocell.textLabel.text = @"我的荣誉";
//            twocell.textLabel.textColor = [UIColor darkGrayColor];
//            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//            twocell.imageView.image = [UIImage imageNamed:@"站长中心-我的荣誉"];
//            UIView *lineView = [[UIView alloc] init];
//            lineView.frame = CGRectMake(15, 43, kWidth-15, 1);
//            lineView.backgroundColor = kLineColor;
//            [twocell addSubview:lineView];
//        } else if (indexPath.row == 1) {
//            twocell.textLabel.text = @"我的团队";
//            twocell.textLabel.textColor = [UIColor darkGrayColor];
//            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//            twocell.imageView.image = [UIImage imageNamed:@"站长中心-我的团队"];
//            UIView *lineView = [[UIView alloc] init];
//            lineView.frame = CGRectMake(15, 43, kWidth-15, 1);
//            lineView.backgroundColor = kLineColor;
//            [twocell addSubview:lineView];
//        } else if (indexPath.row == 2) {
//            twocell.textLabel.text = @"推送信息";
//            twocell.textLabel.textColor = [UIColor darkGrayColor];
//            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//            twocell.imageView.image = [UIImage imageNamed:@"图标"];
//            UIView *lineView = [[UIView alloc] init];
//            lineView.frame = CGRectMake(15, 43, kWidth-15, 1);
//            lineView.backgroundColor = kLineColor;
//            [twocell addSubview:lineView];
//        } else if (indexPath.row == 3) {
//            twocell.textLabel.text = @"站长晒单";
//            twocell.textLabel.textColor = [UIColor darkGrayColor];
//            twocell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//            twocell.imageView.image = [UIImage imageNamed:@"图标"];
//        }
//
//        float sw=23/twocell.imageView.image.size.width;
//        float sh=25/twocell.imageView.image.size.height;
//        twocell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
//
//        twocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//        twocell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return twocell;
//    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        ZIKStationCenterTableViewHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
//        if (self.masterModel) {
//            [sectionHeaderView configWithModel:self.masterModel];
//        }
//        return sectionHeaderView;
//    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = BGColor;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
