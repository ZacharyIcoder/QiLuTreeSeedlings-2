//
//  YLDBaoJiaMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaMessageCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
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
-(void)setModel:(YLDBaoJiaMessageModel *)model
{
    _model=model;
    self.titleLab.text=model.workstationName;
    self.lianxirenLab.text=model.chargelPerson;
    self.timeLab.text=model.quoteTime;
    self.numLab.text=[NSString stringWithFormat:@"%@",model.quantity];
    self.priceLab.text=model.price;
    self.areaLab.text=model.area;
    self.shuomingTextView.text=model.explain;
    if ([model.status integerValue]==1) {
        [self.hezuoActionBtn setImage:[UIImage imageNamed:@"jianlihezuo"] forState:UIControlStateNormal];
        self.hezuoActionBtn.tag=1;
    }
    if ([model.status integerValue]==2) {
        [self.hezuoActionBtn setImage:[UIImage imageNamed:@"yihezuo"] forState:UIControlStateNormal];
        self.hezuoActionBtn.tag=2;
    }
    NSArray *imageAry=[model.image2 componentsSeparatedByString:@","];
    for (int i=0; i<imageAry.count; i++) {
        if (i==0) {
            [self.imageV1 setImageWithURL:[NSURL URLWithString:imageAry[0]] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        }
        if (i==1) {
            [self.imageV2 setImageWithURL:[NSURL URLWithString:imageAry[1]]placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        }
        if (i==2) {
            [self.imageV3 setImageWithURL:[NSURL URLWithString:imageAry[2]]placeholderImage:[UIImage imageNamed:@"MoRentu"]];
        }
    }
}
-(void)hezuoBtnAciotn:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate actionWithtype:sender.tag andModel:self.model];
    }
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
