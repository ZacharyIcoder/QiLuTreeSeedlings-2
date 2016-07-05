//
//  ZIKStationShowHonorView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowHonorView.h"
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface ZIKStationShowHonorView()

@property (weak, nonatomic) IBOutlet UIImageView *honorImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *honorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *honorTimeLabel;
@end

@implementation ZIKStationShowHonorView

+(ZIKStationShowHonorView *)instanceShowHonorView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKStationShowHonorView" owner:nil options:nil];
    ZIKStationShowHonorView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShowViewAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)removeShowViewAction {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
