//
//  ZIKStationOrderQuoteViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderQuoteViewController.h"

@interface ZIKStationOrderQuoteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation ZIKStationOrderQuoteViewController

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
    return 3;
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
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = cell.textLabel.text;
    return cell;
}

- (IBAction)sureButtonClick:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
