//
//  ZIKMyBalanceViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMyBalanceViewController.h"
#import "ZIKMyBalanceFirstTableViewCell.h"
#import "ZIKPayViewController.h"
@interface ZIKMyBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;

@end

@implementation ZIKMyBalanceViewController
@synthesize myTalbeView;
@synthesize titlesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"我的余额";
    [self initUI];
}

- (void)initUI {
    myTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    myTalbeView.delegate = self;
    myTalbeView.dataSource = self;
    [self.view addSubview:myTalbeView];
    [ZIKFunction setExtraCellLineHidden:myTalbeView];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 220;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        ZIKMyBalanceFirstTableViewCell *firstCell = [ZIKMyBalanceFirstTableViewCell cellWithTableView:tableView];
        cell = firstCell;
    }
    else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 64;
    }
    else{
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = self.view.backgroundColor;
    if (0 == section)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:btn];
        btn.frame = CGRectMake(40, 10, Width-80, 44);
        //        [XtomFunction addbordertoView:btn radius:6.0f width:0.0f color:[UIColor clearColor]];
        [btn setBackgroundColor:NavColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //btn.titleLabel.textColor = BackGorundColor;
        [btn setTitle:@"充值" forState:UIControlStateNormal];
        //[btn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(sureButtonPress) forControlEvents:UIControlEventTouchUpInside];
    }

    return footView;
}

- (void)sureButtonPress {
    ZIKPayViewController *payVC  = [[ZIKPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
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
