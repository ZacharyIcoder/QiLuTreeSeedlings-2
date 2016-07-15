//
//  YLDMMPiLiangBianJiCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMMPiLiangBianJiCell.h"
#import "UIDefines.h"
#import "BWTextView.h"

@implementation YLDMMPiLiangBianJiCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-45, 30)];
        nameTextField.tag=20;
        [nameTextField setFont:[UIFont systemFontOfSize:14]];
        nameTextField.placeholder=@"请输入苗木品种";
        nameTextField.borderStyle=UITextBorderStyleRoundedRect;
        nameTextField.textColor=NavColor;
        self.nameTextField=nameTextField;
        [self addSubview:nameTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nameTextField];
        UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2-25, 5, kWidth/2-45, 30)];
        numTextField.placeholder=@"请输入需求数量";
        numTextField.tag=7;
        [numTextField setFont:[UIFont systemFontOfSize:14]];
        numTextField.borderStyle=UITextBorderStyleRoundedRect;
        numTextField.textColor=NavYellowColor;
        numTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.numTextField=numTextField;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:numTextField];
        [self addSubview:numTextField];
        BWTextView *shuomingTextView=[[BWTextView alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
        shuomingTextView.placeholder=@"请输入苗木说明(100字以内)";
       // shuomingTextView.borderStyle=UITextBorderStyleRoundedRect;
        shuomingTextView.textColor=DarkTitleColor;
        shuomingTextView.tag=100;
        self.shuomingTextView = shuomingTextView;
        [shuomingTextView setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:shuomingTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:shuomingTextView];
        shuomingTextView.layer.masksToBounds=YES;
        shuomingTextView.layer.cornerRadius=4;
        shuomingTextView.layer.borderColor=kLineColor.CGColor;
        shuomingTextView.layer.borderWidth=1;
        shuomingTextView.textColor=DarkTitleColor;

        UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 5, 55, 65)];
        self.deleteBtn=deleteBtn;
        [deleteBtn setImage:[UIImage imageNamed:@"deleteRad"] forState:UIControlStateNormal];
        [self addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)deleteBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteWithSelf:andRow:andDic:)]) {
        [self.delegate deleteWithSelf:self andRow:sender.tag andDic:self.messageDic];
    }
}
-(void)setMessageDic:(NSMutableDictionary *)messageDic{
    _messageDic=messageDic;
    self.nameTextField.text=messageDic[@"name"];
    self.numTextField.text=[NSString stringWithFormat:@"%@",messageDic[@"quantity"]];
    NSString *shuomingStr=messageDic[@"description"];
    if (shuomingStr.length>0) {
        self.shuomingTextView.text=shuomingStr;
    }
}
-(BOOL)checkChangeMessage
{
    NSString *nameStr=self.nameTextField.text;
    NSString *numStr=self.numTextField.text;
    if (nameStr.length<=0) {
        [ToastView showTopToast:@"请输入苗木品种"];
        return NO;
    }
    if (numStr.length<=0) {
        [ToastView showTopToast:@"请输入需求数量"];
        return NO;
    }
    return YES;
}
-(void)getChangeMessage
{
//    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSString *nameStr=self.nameTextField.text;
    NSString *numStr=self.numTextField.text;
    if (nameStr.length>0) {
       self.messageDic[@"name"]=nameStr;
    }
    if (numStr.length>0) {
        self.messageDic[@"quantity"]=numStr;
    }
    if (self.shuomingTextView.text.length>0) {
        self.messageDic[@"description"]=self.shuomingTextView.text;
    }else{
        [self.messageDic removeObjectForKey:@"description"];
    }
    
}
- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSInteger kssss=10;
    if (textField.tag>0) {
        kssss=textField.tag;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
- (void)textViewChanged:(NSNotification *)obj {
    BWTextView *textField = (BWTextView *)obj.object;
    NSInteger kssss=10;
    if (textField.tag>0) {
        kssss=textField.tag;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}

//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
