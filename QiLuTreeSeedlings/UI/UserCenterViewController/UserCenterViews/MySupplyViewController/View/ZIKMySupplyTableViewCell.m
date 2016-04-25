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
#import "ZIKFunction.h"
@implementation ZIKMySupplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.timeImageView.tintColor = [UIColor whiteColor];
    self.timeImageView.autoresizingMask = YES;
    self.timeImageView.layer.cornerRadius = 6.0f;
    self.timeImageView.layer.masksToBounds = YES;
    self.timeImageView.backgroundColor = [UIColor whiteColor];

    //self.timeImageView.highlightedImage = [UIImage imageNamed:@"compose_keyboardbutton_background"];
    //UITableViewCellStyle = UITableViewCellStyle
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.timeImageView.backgroundColor = [UIColor whiteColor];

    // Configure the view for the selected state
    //self.backgroundColor = [UIColor blueColor];
    //self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    if (selected) {
//        self.highlighted = YES;
//    }
//    else {
//        self.highlighted = NO;
//    }
//    if ( selected) {
//        UIColor *color = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1];//通过RGB来定义自己的颜色
//        //[objc] view plain copy 在CODE上查看代码片派生到我的代码片
//        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.backgroundView.backgroundColor = color;
//    }
//    else {
//        UIColor *color = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:1];//通过RGB来定义自己的颜色
//        //[objc] view plain copy 在CODE上查看代码片派生到我的代码片
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = color;
//    }

}

-(void)configureCell:(ZIKSupplyModel *)model {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.titleLabel.text = model.title;
    self.timeLabel.textColor = titleLabColor;
    //棵数
    NSString *treeCountString = nil;
    if (model.count.integerValue>=10000) {
        treeCountString = [NSString stringWithFormat:@"%d万棵",(int)model.count.integerValue/10000];
    }
    else {
        treeCountString = [NSString stringWithFormat:@"%@棵",model.count];
    }
    self.countLabel.text = treeCountString;
    self.countLabel.textColor = detialLabColor;
    NSDate *timeDate = [ZIKFunction getDateFromString:model.createTime];
    NSString *time = [ZIKFunction compareCurrentTime:timeDate];
    self.timeLabel.text  = time;

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
    darkColor.color = detialLabColor;
    darkColor.effectRange = NSMakeRange(0, 3);
    
    self.priceLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];
    if (model.isSelect) {
        self.selected = YES;
        self.isSelect = YES;
        //self.selectionStyle = UITableViewCellSelectionStyleBlue;
        //self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    //self.isSelected  = model.
   // self.isSelected;
//    if (model.edit.integerValue == 1) {
//        self.selected = YES;
//    }

}
@end
