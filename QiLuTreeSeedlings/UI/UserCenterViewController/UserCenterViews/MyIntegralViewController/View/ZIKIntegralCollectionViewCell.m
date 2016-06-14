//
//  ZIKIntegralCollectionViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/31.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKIntegralCollectionViewCell.h"
#import "ZIKIntegraExchangeModel.h"
#import "StringAttributeHelper.h"//富文本

@implementation ZIKIntegralCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCell:(ZIKIntegraExchangeModel *)model {
    self.integralLabel.text  = [NSString stringWithFormat:@"所需积分%@分",model.integral];
    NSString *priceString = nil;
    priceString = [NSString stringWithFormat:@"¥%@",model.money];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:20.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 1);
    self.moneyLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont]];
}

@end
