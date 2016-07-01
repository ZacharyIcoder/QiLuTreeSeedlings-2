//
//  YLDHeZuoDetialGZZView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoDetialGZZView.h"
#import "UIDefines.h"
@implementation YLDHeZuoDetialGZZView
+(YLDHeZuoDetialGZZView *)yldHeZuoDetialGZZView
{
    YLDHeZuoDetialGZZView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDHeZuoDetialGZZView" owner:self options:nil] lastObject];

    return view;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    self.areaLab.text=dic[@"area"];
    
//    NSArray *creatTime=[dic[@"createTime"] componentsSeparatedByString:@" "];
    self.numLab.text=[NSString stringWithFormat:@"%@",dic[@"quantity"]];
    self.NameLab.text=dic[@"workstationName"];
    self.priceLab.text=[NSString stringWithFormat:@"%@",dic[@"price"]];

    self.userNameLab.text=dic[@"chargelPerson"];
    self.backImageV.image=[self imageWithSize:self.backImageV.frame.size borderColor:NavColor borderWidth:0.5];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
