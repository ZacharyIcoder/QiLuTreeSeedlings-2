//
//  ZIKBottomDeleteTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKBottomDeleteTableViewCell.h"
#import "StringAttributeHelper.h"

@implementation ZIKBottomDeleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.backgroundColor = yellowButtonColor;
//    [self.seleteImageButton setImage:[UIImage imageNamed:@"待选"] forState:UIControlStateNormal];
//    [self.seleteImageButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateSelected];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kcellID = @"ZIKBottomDeleteTableViewCellID";
    ZIKBottomDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKBottomDeleteTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setIsAllSelect:(BOOL)isAllSelect {
    _isAllSelect = isAllSelect;
    if (isAllSelect) {
        [self.seleteImageButton setImage:[UIImage imageNamed:@"充值成功76x76-2"] forState:UIControlStateNormal];
//        UIColor *color = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1];//通过RGB来定义自己的颜色
//        //[objc] view plain copy 在CODE上查看代码片派生到我的代码片
//        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.backgroundView.backgroundColor = color;

    }
    else {
        [self.seleteImageButton setImage:[UIImage imageNamed:@"待选"] forState:UIControlStateNormal];
    }
}

-(void)setCount:(NSInteger)count {
    _count = count;
    NSString *priceString = nil;
    priceString = [NSString stringWithFormat:@"合计 : %ld 条",(long)count];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:16.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = titleLabColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:17.0f];
    partFont.effectRange = NSMakeRange(4, 3);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(4, 3);

    self.countLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
