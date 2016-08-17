//
//  ZIKCaiGouDetailHaveBuyTopView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCaiGouDetailHaveBuyTopView.h"
@interface ZIKCaiGouDetailHaveBuyTopView ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@end
@implementation ZIKCaiGouDetailHaveBuyTopView

+(ZIKCaiGouDetailHaveBuyTopView *)instanceTopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKCaiGouDetailHaveBuyTopView" owner:nil options:nil];
    ZIKCaiGouDetailHaveBuyTopView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowViewAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)ShowViewAction {
    if ([self.delegate respondsToSelector:@selector(gotoDetail)]) {
        [self.delegate gotoDetail];
    }
}

-(void)setOrderNo:(NSString *)orderNo {
    _orderNo = orderNo;
    self.numberLabel.text = orderNo;
}
@end
