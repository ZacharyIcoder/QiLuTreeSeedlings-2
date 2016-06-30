//
//  ZIKStationOrderQuoteViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderQuoteViewController.h"
#import "BWTextView.h"

@interface ZIKStationOrderQuoteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) BWTextView *countTextView;
@property (nonatomic, strong) BWTextView *priceTextView;
@property (nonatomic, strong) BWTextView *contentTextView;
@end

@implementation ZIKStationOrderQuoteViewController
{
    UILabel *detailLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"报价";
    self.titleArray = @[@[@"苗木名称",@"苗木数量",@"报价要求",@"规格要求"],@[@"报价价格",@"可供数量",@"苗圃地址",@"报价说明"],@[@"苗木图片"]];
    self.quoteTableView.delegate = self;
    self.quoteTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array  = self.titleArray[section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *tableViewCellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellId];
        detailLabel = [[UILabel alloc] init];
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = detialLabColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    if (indexPath.section == 0) {
        detailLabel.frame = CGRectMake(100, 5, kWidth-120, 34);
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = DarkTitleColor;
        detailLabel.font = [UIFont systemFontOfSize:15.0f];
        if (indexPath.row == 0) {
            detailLabel.text = self.name;
        } else if (indexPath.row == 1) {
            detailLabel.text = self.count;
        } else if (indexPath.row == 2) {
            detailLabel.text = self.quoteRequirement;
        } else if (indexPath.row == 3) {
            detailLabel.text = self.standardRequirement;
        }
        [cell addSubview:detailLabel];

    } else if (indexPath.section == 1) {
        UITextField *priceTextField = [[UITextField alloc] init];
        priceTextField.frame = CGRectMake(100, 5, kWidth-120, 34);
        priceTextField.layer.masksToBounds = YES;
        priceTextField.layer.cornerRadius = 6.0f;
        priceTextField.layer.borderWidth =  1;
        priceTextField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        priceTextField.placeholder = @"ewifiwefjiwf";
        [cell addSubview:priceTextField];
    }
    return cell;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
