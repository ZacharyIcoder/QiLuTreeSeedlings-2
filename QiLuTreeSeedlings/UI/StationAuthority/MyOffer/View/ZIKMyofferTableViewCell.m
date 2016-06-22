//
//  ZIKMyofferTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyofferTableViewCell.h"
#import "ZIKMyOfferQuoteListModel.h"
#import "UIDefines.h"
#import "StringAttributeHelper.h"

@interface ZIKMyofferTableViewCell ()
/**
 *  订单类型ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImageView;
/**
 *  苗木名称宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemNameLabelWidthLayoutConstraint;
/**
 *  苗木名称Label
 */
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
/**
 *  苗木数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *itemQuantityLabel;
/**
 *  状态ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
/**
 *  报价价格Label
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  报价数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *quoteQuantityLabel;
/**
 *  报价时间Label
 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/**
 *  截止日期Label
 */
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
/**
 *  订单名称Label
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
/**
 *  工程公司Label
 */
@property (weak, nonatomic) IBOutlet UILabel *engineeringCompanyLabel;

@end

@implementation ZIKMyofferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.itemNameLabel.backgroundColor     = NavColor;
    self.itemNameLabel.layer.masksToBounds = YES;
    self.itemNameLabel.layer.cornerRadius  = 5.0f;
    self.itemQuantityLabel.textColor       = detialLabColor;
    self.createTimeLabel.textColor         = detialLabColor;
    self.endDateLabel.textColor            = detialLabColor;
    self.orderNameLabel.textColor          = detialLabColor;
    self.engineeringCompanyLabel.textColor = detialLabColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kdzZIKMyofferTableViewCellID = @"kZIKMyofferTableViewCellID";
    ZIKMyofferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kdzZIKMyofferTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMyofferTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKMyOfferQuoteListModel *)model {
    self.createTimeLabel.text = [NSString stringWithFormat:@"报价日期: %@",model.createTime];
    self.endDateLabel.text = [NSString stringWithFormat:@"截止日期: %@",model.endDate];
    if ([model.status isEqualToString:@"1"]) {//已报价
        self.statusImageView.image = [UIImage imageNamed:@"zt已报价"];
    } else if ([model.status isEqualToString:@"2"]) {//已合作
        self.statusImageView.image = [UIImage imageNamed:@"zt已合作"];
    } else if ([model.status isEqualToString:@"3"]) {//已过期
        self.statusImageView.image = [UIImage imageNamed:@"zt已过期"];
    }
    if ([model.orderType isEqualToString:@"求购单"]) {
        self.orderTypeImageView.image = [UIImage imageNamed:@"标签-求购"];
    } else if ([model.orderType isEqualToString:@"采购单"]) {
        self.orderTypeImageView.image = [UIImage imageNamed:@"标签-采购"];
    } else if ([model.orderType isEqualToString:@"询价单"]) {
        self.orderTypeImageView.image = [UIImage imageNamed:@"标签-询价"];
    }
    self.itemQuantityLabel.text = [NSString stringWithFormat:@"需求: %@棵",model.itemQuantity];
    self.orderNameLabel.text = model.orderName;
    self.engineeringCompanyLabel.text = model.engineeringCompany;
    self.itemNameLabel.text = model.itemName;
   CGRect rect =  [model.itemName boundingRectWithSize:CGSizeMake(kWidth/2, CGFLOAT_MAX)
                          options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                          context:nil];
    self.itemNameLabelWidthLayoutConstraint.constant = rect.size.width+8;
    NSString *priceString = [NSString stringWithFormat:@"我的报价: ¥%@",model.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:13.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = detialLabColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:17.0f];
    partFont.effectRange = NSMakeRange(5, priceString.length-5);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(5, priceString.length-5);

    self.priceLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

    NSString *quoteStr = [NSString stringWithFormat:@"供应: %@棵",model.quoteQuantity];
    FontAttribute *quotefullFont = [FontAttribute new];
    quotefullFont.font = [UIFont systemFontOfSize:13.0f];
    quotefullFont.effectRange  = NSMakeRange(0, quoteStr.length);
    ForegroundColorAttribute *quotefullColor = [ForegroundColorAttribute new];
    quotefullColor.color = detialLabColor;
    quotefullColor.effectRange = NSMakeRange(0,quoteStr.length);
    //局部设置
    FontAttribute *quotepartFont = [FontAttribute new];
    quotepartFont.font = [UIFont systemFontOfSize:17.0f];
    quotepartFont.effectRange = NSMakeRange(3, quoteStr.length-3);
    ForegroundColorAttribute *quotedarkColor = [ForegroundColorAttribute new];
    quotedarkColor.color = yellowButtonColor;
    quotedarkColor.effectRange = NSMakeRange(3, quoteStr.length-3);

    self.quoteQuantityLabel.attributedText = [quoteStr mutableAttributedStringWithStringAttributes:@[quotefullFont,quotepartFont,quotefullColor,quotedarkColor]];

}

@end
