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
#import "ZIKSupplyModel.h"
@implementation ZIKMySupplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.timeImageView.tintColor           = [UIColor whiteColor];
    self.timeImageView.autoresizingMask    = YES;
    self.timeImageView.layer.cornerRadius  = 6.0f;
    self.timeImageView.layer.masksToBounds = YES;
    self.refreshLabel.textColor            = NavColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configureCell:(ZIKSupplyModel *)model {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.titleLabel.text = model.title;
    self.timeLabel.textColor = titleLabColor;
    //棵(株)数
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
    priceString = [NSString stringWithFormat:@"上车价 ¥%@",model.price];

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
     }
    if ([model.state isEqualToString:@"3"]) {
        [self.backImageView setImage:[UIImage imageNamed:@"标签-已退回.png"]];
    }
    if ([model.state isEqualToString:@"2"]) {
        [self.backImageView setImage:[UIImage imageNamed:@"yitongguo"]];
    }
    if ([model.state isEqualToString:@"5"]) {
        [self.backImageView setImage:[UIImage imageNamed:@"yiguoqi"]];
    }
    //2审核通过， 3退回， 5过期
    if ([model.shuaxin isEqualToString:@"1"]) {
        self.refreshLabel.hidden = NO;
        self.refreshImageView.hidden = NO;
    }
    else {
        self.refreshLabel.hidden = YES;
        self.refreshImageView.hidden = YES;
    }

}
@end
