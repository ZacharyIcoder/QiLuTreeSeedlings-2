//
//  ZIKQuoteTextField.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/27.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKQuoteTextField.h"
#import "UIDefines.h"
@implementation ZIKQuoteTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.font = [UIFont systemFontOfSize:15.0f];
        self.layer.cornerRadius = 6.0f;
        self.layer.borderWidth  =  1;
        self.layer.borderColor  = [kLineColor CGColor];
    }
    return self;
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{

    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些

    return inset;

}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );

    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

////控制清除按钮的位置
//-(CGRect)clearButtonRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//}
////控制左视图位置
//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
//    return inset;
//    //return CGRectInset(bounds,50,0);
//}
//
////控制placeHolder的颜色、字体
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    [[UIColororangeColor] setFill];
//
//    [[selfplaceholder] drawInRect:rectwithFont:[UIFontsystemFontOfSize:20]];
//}
//
////下面是使用CustomTextField的代码，可放在viewDidLoad等方法中
//_textField = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 150, 280, 30)];
//_textField.placeholder = @"请输入帐号信息";
//_textField.borderStyle = UITextBorderStyleRoundedRect;
//_textField.textAlignment = UITextAlignmentLeft;
//_textField.delegate = self;
//_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//_textField.text = @"aa";
//UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-iwant-2.png"]];
//_textField.leftView = imgv;
//_textField.leftViewMode = UITextFieldViewModeAlways;
//[self.view addSubview:_textField];

@end
