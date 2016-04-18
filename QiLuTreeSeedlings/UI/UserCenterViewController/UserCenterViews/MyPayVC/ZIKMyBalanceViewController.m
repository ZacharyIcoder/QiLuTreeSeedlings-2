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
#import "ZIKPayRecordViewController.h"
@interface ZIKMyBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;
@property (nonatomic, strong) NSString *moneyPrice;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getprice];
}

- (void)getprice {
    [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] integerValue] == 1) {
            self.moneyPrice = [responseObject[@"result"] objectForKey:@"money"];
            [self.myTalbeView reloadData];
        }
        else {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:250 withSuperView:self.view];
        }

    } failure:^(NSError *error) {

    }];
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
        if (self.moneyPrice) {
            [firstCell configureCell:self.moneyPrice];
        }
        cell = firstCell;
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1) {
        static NSString *kCellTwoId = @"twoCellId";
        UITableViewCell *twocell = [tableView dequeueReusableCellWithIdentifier:kCellTwoId];
        if (!twocell) {
            twocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTwoId];
        }
        twocell.textLabel.text = @"消费记录";
        twocell.textLabel.textColor = [UIColor darkGrayColor];
        twocell.imageView.image = [UIImage imageNamed:@"消费记录40x40"];

        float sw=23/twocell.imageView.image.size.width;
        float sh=25/twocell.imageView.image.size.height;
        twocell.imageView.transform=CGAffineTransformMakeScale(sw,sh);

        twocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell = twocell;
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
        ZIKPayRecordViewController *payRecordVC = [[ZIKPayRecordViewController alloc] init];
        [self.navigationController pushViewController:payRecordVC animated:YES];
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
        [btn setBackgroundColor:yellowButtonColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:@"充值" forState:UIControlStateNormal];
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


@end
