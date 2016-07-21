//
//  YLDSearchNavView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDSearchNavView.h"
#import "UIDefines.h"
@implementation YLDSearchNavView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)init
{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(75, 0,kWidth-80, 64);
        UIView *texeView=[[UIView alloc]initWithFrame:CGRectMake(5, 23, kWidth-100, 32)];
        [texeView setBackgroundColor:[UIColor whiteColor]];
        texeView.layer.masksToBounds=YES;
        texeView.layer.cornerRadius=5;
        [self addSubview:texeView];
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, kWidth-160, 30)];
        textField.delegate=self;
        textField.tag=11;
        self.textfield=textField;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        [textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:textField];
        [texeView addSubview:textField];
        UIButton *hidingBtn=[[UIButton alloc]initWithFrame:CGRectMake(texeView.frame.size.width-40, 1.5, 27, 27)];
        [hidingBtn setImage:[UIImage imageNamed:@"searchOrange"] forState:UIControlStateNormal];
        [hidingBtn addTarget: self action:@selector(hidingSelf) forControlEvents:UIControlEventTouchUpInside];
        
        [texeView addSubview:hidingBtn];
    }
    return self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.tag=22;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.tag=11;
}
-(void)valueChanged:(UITextField *)textField
{
    if (textField.tag!=22) {
        return;
    }
    BOOL teBool = [textField isFirstResponder];
    if (!teBool) {
        return;
    }
    NSString *toBeString = textField.text;
    NSInteger kssss=10;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
          
                if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                        [self.delegate textFieldChangeVVWithStr:textField.text];
                    }
                return;
            }
            if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                [self.delegate textFieldChangeVVWithStr:textField.text];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
            if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self];
            textField.text = [toBeString substringToIndex:kssss];
            if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                    [self.delegate textFieldChangeVVWithStr:textField.text];
            }
            return;
        }
        if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
            [self.delegate textFieldChangeVVWithStr:textField.text];
        }
    }

}
-(void)hidingSelf
{
    self.hidden=YES;
    if (self.delegate) {
        [self.delegate hidingAction];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
