//
//  ZIKWorkstationSelectListView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectListView.h"
#import "ZIKWorkstationSelectListViewTableViewCell.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface ZIKWorkstationSelectListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation ZIKWorkstationSelectListView

+(ZIKWorkstationSelectListView *)instanceSelectListView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKWorkstationSelectListView" owner:nil options:nil];
    ZIKWorkstationSelectListView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShowViewAction)];
    self.bottomView.userInteractionEnabled = YES;
    [self.bottomView addGestureRecognizer:tapGesture];
    self.selectAraeTableView.delegate = self;
    self.selectAraeTableView.dataSource = self;
    _isShow = NO;
}

- (void)removeShowViewAction {
    [UIView animateWithDuration:.001 animations:^{
        self.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    } completion:^(BOOL finished) {
        _isShow = NO;
    }];
}

- (void)showView {
    [UIView animateWithDuration:.001 animations:^{
        self.frame = CGRectMake(0, 64+46+4, SCREEN_SIZE.width, SCREEN_SIZE.height-64-46-4);
    } completion:^(BOOL finished) {
        _isShow = YES;
    }];
}

-(void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (!isShow) {
        [self removeShowViewAction];
    } else {
        [self showView];
    }
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfRowsInfTable:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZIKWorkstationSelectListViewTableViewCell *cell = [ZIKWorkstationSelectListViewTableViewCell cellWithTableView:tableView];
    cell.nameLable.text = [self.dataSource selectListView:self titleForRow:indexPath.row];
    cell.code = [self.dataSource selectListView:self codeForRow:indexPath.row];
    cell.selectImageView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIKWorkstationSelectListViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.hidden = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.listdelegate didSelectRowAtIndexPath:self title:cell.nameLable.text coel:cell.code];
    [self removeShowViewAction];
}
@end
