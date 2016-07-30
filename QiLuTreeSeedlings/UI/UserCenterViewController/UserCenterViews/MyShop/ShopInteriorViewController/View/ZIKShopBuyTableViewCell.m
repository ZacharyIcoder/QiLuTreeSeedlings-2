//
//  ZIKShopBuyTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/29.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShopBuyTableViewCell.h"
#import "ZIKShopBuyModel.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
#import "StringAttributeHelper.h"
@interface ZIKShopBuyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ZIKShopBuyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.textColor = titleLabColor;
    self.addressLabel.textColor = detialLabColor;
    self.timeLabel.textColor = detialLabColor;
    self.countLabel.textColor = detialLabColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKShopBuyTableViewCellID = @"kZIKShopBuyTableViewCellID";
    ZIKShopBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKShopBuyTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShopBuyTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;

}

- (void)configureCell:(ZIKShopBuyModel *)model {
    self.titleLabel.text = model.title;
    self.addressLabel.text = model.area;
    self.countLabel.text = model.count;
    NSDate *creatTimeDate = [ZIKFunction getDateFromString:model.createTime];
    self.timeLabel.text = [ZIKFunction compareCurrentTime:creatTimeDate];
    NSString *priceString = [NSString stringWithFormat:@"价格 ¥%@", model.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:18.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = yellowButtonColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 4);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = detialLabColor;
    darkColor.effectRange = NSMakeRange(0, 3);

    self.countLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];



}
@end
