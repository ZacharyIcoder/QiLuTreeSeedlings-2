//
//  YLDBaoJiaMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaMessageCell.h"
#import "UIDefines.h"
@implementation YLDBaoJiaMessageCell
+(YLDBaoJiaMessageCell *)ylBdaoJiaMessageCell
{
    YLDBaoJiaMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDBaoJiaMessageCell" owner:self options:nil] lastObject];
    cell.backV.layer.masksToBounds=YES;
    cell.backV.layer.cornerRadius=5;
    cell.backV.image=[YLDBaoJiaMessageCell  imageWithSize:cell.backV.frame.size borderColor:NavColor borderWidth:1];
    cell.shuomingTextView.editable=NO;
    return cell;
    
}
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
