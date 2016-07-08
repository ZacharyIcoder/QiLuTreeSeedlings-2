//
//  YLDDingDanMMBianJiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanMMBianJiViewController.h"
#import "UIDefines.h"
@interface YLDDingDanMMBianJiViewController ()
@property (nonatomic,copy)NSString *uid;
@end

@implementation YLDDingDanMMBianJiViewController
-(id)initWithUid:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"苗木编辑";
    [self CreatAddView];
    // Do any additional setup after loading the view.
}
-(UIView *)CreatAddView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 80)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UITextField *nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kWidth/2-15, 30)];
    
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    nameTextField.tag=20;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    nameTextField.placeholder=@"请输入苗木品种";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.textColor=NavColor;
    [view addSubview:nameTextField];
    
    UITextField *numTextField=[[UITextField alloc]initWithFrame:CGRectMake(kWidth/2+5, 5, kWidth/2-15, 30)];
    numTextField.placeholder=@"请输入需求数量";
    
    numTextField.tag=7;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:numTextField];
    [numTextField setFont:[UIFont systemFontOfSize:14]];
    numTextField.borderStyle=UITextBorderStyleRoundedRect;
    numTextField.textColor=NavYellowColor;
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:numTextField];
    UITextField *shuomingTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, kWidth-80, 30)];
    shuomingTextField.tag=100;
    shuomingTextField.placeholder=@"请输入苗木说明(100字以内)";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:shuomingTextField];
    shuomingTextField.borderStyle=UITextBorderStyleRoundedRect;
    shuomingTextField.textColor=DarkTitleColor;
    
    [shuomingTextField setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:shuomingTextField];
    [self.view addSubview:view];
    UIImageView *lineImagV=[[UIImageView alloc]initWithFrame:CGRectMake(10,80-0.5, kWidth-20, 0.5)];
    [lineImagV setBackgroundColor:kLineColor];
    
    [view addSubview:lineImagV];
    return view;
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
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",kssss] withOriginY:250 withSuperView:self.view];
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
