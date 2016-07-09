//
//  ZIKWorkstationSelectView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectView.h"

@implementation ZIKWorkstationSelectView



+(ZIKWorkstationSelectView *)instanceSelectAreaView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKWorkstationSelectView" owner:nil options:nil];
    ZIKWorkstationSelectView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    self.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    self.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    self.layer.shadowOffset  = CGSizeMake(0, 3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius  = 3;//阴影半径，默认3
//    self.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)provinceButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelector:title:)]) {
        [self.delegate didSelector:nil title:nil];
    }
}

- (IBAction)cityButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelector:title:)]) {
        [self.delegate didSelector:nil title:nil];
    }

}

- (IBAction)countryButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelector:title:)]) {
        [self.delegate didSelector:nil title:nil];
    }

}
@end
