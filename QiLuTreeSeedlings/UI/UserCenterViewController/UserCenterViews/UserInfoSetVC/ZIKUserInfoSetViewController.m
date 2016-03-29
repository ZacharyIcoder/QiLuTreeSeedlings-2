//
//  ZIKUserInfoSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKUserInfoSetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKUserNameSetViewController.h"
#import "ZIKPasswordSetViewController.h"
@interface ZIKUserInfoSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView    *_globalHeadImageView; //个人头像
    UIImage        *_globalHeadImage;
    UIImageView    *cellHeadImageView;
    UILabel        *cellNameLabel;
}
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;

@end

@implementation ZIKUserInfoSetViewController
@synthesize myTalbeView;
@synthesize titlesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"个人信息";
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (myTalbeView) {
        [myTalbeView reloadData];
    }
}

- (void)initData {
    titlesArray = @[@[@"我的头像",@"姓名",@"密码",@"我的二维码"],@[@"手机号"]];
}

- (void)initUI {
    myTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    myTalbeView.delegate = self;
    myTalbeView.dataSource = self;
    [self.view addSubview:myTalbeView];
    [ZIKFunction setExtraCellLineHidden:myTalbeView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (!cellNameLabel) {
            cellNameLabel = [[UILabel alloc] init];
        }
        if (!cellHeadImageView) {
            cellHeadImageView = [[UIImageView alloc] init];
        }
    }
    cell.textLabel.text = titlesArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cellHeadImageView.frame = CGRectMake(kWidth-75, 7, 30, 30);
                if (![ZIKFunction xfunc_check_strEmpty:APPDELEGATE.userModel.headUrl]) {
                    [cellHeadImageView setImageWithURL:[NSURL URLWithString:APPDELEGATE.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
                }
                else {
                    cellHeadImageView.image = [UIImage imageNamed:@"UserImageV"];
                }
                [cell addSubview:cellHeadImageView];
            }
                break;
            case 1: {
                cellNameLabel.frame = CGRectMake(55, 7, kWidth-55-30, 30);
                cellNameLabel.text = APPDELEGATE.userModel.name;
                cellNameLabel.textAlignment = NSTextAlignmentRight;
                [cell addSubview:cellNameLabel];
            }
                break;
            case 2: {

            }
                break;
            case 3: {

            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {

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
            case 1: {
                ZIKUserNameSetViewController *nameVC = [[ZIKUserNameSetViewController alloc] init];
                [self.navigationController pushViewController:nameVC animated:YES];
            }
                break;
            case 2: {
                ZIKPasswordSetViewController *passwordVC = [[ZIKPasswordSetViewController alloc] init];
                [self.navigationController pushViewController:passwordVC animated:YES];
            }
                break;
            case 3: {

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
