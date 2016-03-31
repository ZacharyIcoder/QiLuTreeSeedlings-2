//
//  ZIKSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSetViewController.h"

@interface ZIKSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
}
@property (nonatomic, strong) NSArray     *titlesArray;
@property (nonatomic, strong) UITableView *myTalbeView;

@end

@implementation ZIKSetViewController
@synthesize myTalbeView;
@synthesize titlesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"设置";
    [self initUI];
}

- (void)initUI {
    myTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    myTalbeView.delegate   = self;
    myTalbeView.dataSource = self;
    [self.view addSubview:myTalbeView];
    [ZIKFunction setExtraCellLineHidden:myTalbeView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"kcellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        titleLabel = [[UILabel alloc] init];
    }
    if (indexPath.row == 0) {

    }
    else if (indexPath.row == 1) {

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
