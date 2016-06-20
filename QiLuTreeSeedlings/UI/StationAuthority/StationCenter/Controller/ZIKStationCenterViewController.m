//
//  ZIKStationCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterViewController.h"


@interface ZIKStationCenterViewController ()
@property (nonatomic, strong) UITableView *centerTableView;
@end



@implementation ZIKStationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)initUI {
    UITableView *centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    [self.view addSubview:centerTableView];
    self.centerTableView = centerTableView;

//    self.centerTableView.sectionHeaderHeight    = HEADER_HEIGHT;
////    self.uniformRowHeight                     = DEFAULT_ROW_HEIGHT;
////    self.openSectionIndex                     = NSNotFound;
//
//    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ZIKStationCenterTableViewHeaderView" bundle:nil];
//    [self.centerTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}

@end
