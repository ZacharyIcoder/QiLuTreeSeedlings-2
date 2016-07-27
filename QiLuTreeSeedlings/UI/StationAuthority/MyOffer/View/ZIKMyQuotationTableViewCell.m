//
//  ZIKMyQuotationTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyQuotationTableViewCell.h"
#import "ZIKMyOfferQuoteListModel.h"
#import "UIDefines.h"
#import "StringAttributeHelper.h"

@interface ZIKMyQuotationTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bottomBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineeringCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteQuantityLabel;

@end

@implementation ZIKMyQuotationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kdzZIKMyQuotationTableViewCellID = @"kdzZIKMyQuotationTableViewCellID";
    ZIKMyQuotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kdzZIKMyQuotationTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMyQuotationTableViewCell" owner:self options:nil] lastObject];
        cell.bottomBgImageView.image = [ZIKMyQuotationTableViewCell imageWithSize:cell.bottomBgImageView.frame.size borderColor:NavColor borderWidth:1];
    }
    return cell;
}

- (void)configureCell:(ZIKMyOfferQuoteListModel *)model {
    self.createTimeLabel.text = model.createTime;
    self.endDateLabel.text = [NSString stringWithFormat:@"截止日期: %@",model.endDate];
    if ([model.status isEqualToString:@"1"]) {//已报价
        self.statusImageView.image = [UIImage imageNamed:@"已报价"];
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
    self.itemQuantityLabel.text = [NSString stringWithFormat:@"需求: %@棵(株)",model.itemQuantity];
    self.orderNameLabel.text = model.orderName;
    self.engineeringCompanyLabel.text = model.engineeringCompany;
    self.itemNameLabel.text = model.itemName;
//    CGRect rect =  [model.itemName boundingRectWithSize:CGSizeMake(kWidth/2, CGFLOAT_MAX)
//                                                options:NSStringDrawingUsesLineFragmentOrigin
//                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
//                                                context:nil];

    NSString *priceString = [NSString stringWithFormat:@"报价单价: ¥%@",model.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:14.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = detialLabColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:18.0f];
    partFont.effectRange = NSMakeRange(7, priceString.length-7);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(5, priceString.length-5);

    self.priceLabel.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

<<<<<<< HEAD
    NSString *quoteStr = [NSString stringWithFormat:@"报价数量: %@棵",model.quoteQuantity];
=======
    NSString *quoteStr = [NSString stringWithFormat:@"供应: %@棵(株)",model.quoteQuantity];
>>>>>>> origin/master
    FontAttribute *quotefullFont = [FontAttribute new];
    quotefullFont.font = [UIFont systemFontOfSize:14.0f];
    quotefullFont.effectRange  = NSMakeRange(0, quoteStr.length);
    ForegroundColorAttribute *quotefullColor = [ForegroundColorAttribute new];
    quotefullColor.color = detialLabColor;
    quotefullColor.effectRange = NSMakeRange(0,quoteStr.length);
    //局部设置
    FontAttribute *quotepartFont = [FontAttribute new];
    quotepartFont.font = [UIFont systemFontOfSize:18.0f];
    quotepartFont.effectRange = NSMakeRange(5, quoteStr.length-6);
    ForegroundColorAttribute *quotedarkColor = [ForegroundColorAttribute new];
    quotedarkColor.color = yellowButtonColor;
    quotedarkColor.effectRange = NSMakeRange(5, quoteStr.length-5);

    self.quoteQuantityLabel.attributedText = [quoteStr mutableAttributedStringWithStringAttributes:@[quotefullFont,quotepartFont,quotefullColor,quotedarkColor]];
}

+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {1, 0.2};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
