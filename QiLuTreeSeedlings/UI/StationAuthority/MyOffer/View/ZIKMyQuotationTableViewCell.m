//
//  ZIKMyQuotationTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyQuotationTableViewCell.h"
#import "UIDefines.h"

@interface ZIKMyQuotationTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bottomBgImageView;

@end

@implementation ZIKMyQuotationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomBgImageView.image = [self imageWithSize:self.bottomBgImageView.frame.size borderColor:NavColor borderWidth:1];
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
    }
    return cell;
}

- (void)configureCell:(ZIKMyOfferQuoteListModel *)model {
//     cell.backV.image=[YLDBaoJiaMessageCell  imageWithSize:cell.backV.frame.size borderColor:NavColor borderWidth:1];
}

- (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
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
