//
//  ZIKWorkstationSelectListView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectListView.h"
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@interface ZIKWorkstationSelectListView ()//<UITableViewDelegate,UITableViewDataSource>
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
}

- (void)removeShowViewAction {
    [UIView animateWithDuration:.001 animations:^{
        self.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}
//
@end
