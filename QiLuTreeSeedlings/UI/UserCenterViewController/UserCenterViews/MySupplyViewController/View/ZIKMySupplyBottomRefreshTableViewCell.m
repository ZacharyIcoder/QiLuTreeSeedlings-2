//
//  ZIKMySupplyBottomRefreshTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKMySupplyBottomRefreshTableViewCell.h"
#import "UIDefines.h"
#import "StringAttributeHelper.h"

@implementation ZIKMySupplyBottomRefreshTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.refreshButton setBackgroundColor:yellowButtonColor];
    //[self.refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //self.refreshButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKMySupplyBottomRefreshTableViewCellID = @"ZIKMySupplyBottomRefreshTableViewCellID";
    ZIKMySupplyBottomRefreshTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKMySupplyBottomRefreshTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMySupplyBottomRefreshTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setCount:(NSInteger)count {
    _count = count;
    NSString *priceString = nil;
    priceString = [NSString stringWithFormat:@"合计 : %ld 条 每次最多选5条",(long)count];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:16.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = titleLabColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:17.0f];
    partFont.effectRange = NSMakeRange(4, 2);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(4, 2);

    FontAttribute *tailFont = [FontAttribute new];
    tailFont.font = [UIFont systemFontOfSize:14.0f];
    tailFont.effectRange = NSMakeRange(priceString.length-7,7);
    ForegroundColorAttribute *yellowColor = [ForegroundColorAttribute new];
    yellowColor.color = yellowButtonColor;
    yellowColor.effectRange = NSMakeRange(priceString.length-7,7);

    self.countLable.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,tailFont,fullColor,darkColor,yellowColor]];
    
}


@end
