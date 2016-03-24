//
//  ZIKMySupplyTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "StringAttributeHelper.h"
#import "UIDefines.h"
@implementation ZIKMySupplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(ZIKSupplyModel *)model {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.titleLabel.text = model.title;
    //棵数
    NSString *treeCountString = nil;
    if (model.count.integerValue>=10000) {
        treeCountString = [NSString stringWithFormat:@"%d万棵",(int)model.count.integerValue/10000];
    }
    else {
        treeCountString = [NSString stringWithFormat:@"%@棵",model.count];
    }
    self.countLabel.text = treeCountString;
    self.timeLabel.text  = model.createTime;
//    //时间
//    NSString* timeStr = model.createTime;//@"2011-01-26 17:40:50";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    //价格
    NSString *priceString = nil;
    if (model.price.floatValue >= 10000) {
        priceString = [NSString stringWithFormat:@"上车价 ¥%.1f万",model.price.floatValue/10000];
    }
    else {
        priceString = [NSString stringWithFormat:@"上车价 ¥%.1f",model.price.floatValue];
    }
   
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:19.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = kRGB(253, 133, 26, 1);
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 5);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = [UIColor darkGrayColor];
    darkColor.effectRange = NSMakeRange(0, 3);
    
    self.priceLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];
    
}
@end
