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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //self.backgroundColor = [UIColor blueColor];
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    darkColor.color = [UIColor darkGrayColor];
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
