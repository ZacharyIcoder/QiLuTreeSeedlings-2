//
//  ZIKMySupplyDetailBottomShareTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyDetailBottomShareTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKMySupplyDetailBottomShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hintLabel.textColor = detialLabColor;
    self.shareBtn.backgroundColor = NavColor;
    self.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    self.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    self.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius  = 3;//阴影半径，默认3
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
