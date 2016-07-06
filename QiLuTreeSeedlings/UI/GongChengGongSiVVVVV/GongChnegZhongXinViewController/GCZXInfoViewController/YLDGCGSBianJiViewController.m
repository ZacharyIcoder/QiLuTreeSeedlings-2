//
//  YLDGCGSBianJiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCGSBianJiViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface YLDGCGSBianJiViewController ()
@property (nonatomic)NSInteger type;
@property (nonatomic,weak)UITextField *textField;
@end

@implementation YLDGCGSBianJiViewController
-(id)initWithType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 70, kWidth, 44)];
    [self.view addSubview:textField];
    if (self.type==1) {
        self.vcTitle=@"联系人";
        textField.placeholder=@"请输入姓名";
    }
    if (self.type==2) {
        self.vcTitle=@"电话";
        textField.placeholder=@"请输入电话";
        textField.keyboardType=UIKeyboardTypeNumberPad;
    }
    if (self.type==3) {
        self.vcTitle=@"公司地址";
        textField.placeholder=@"请输入公司地址";
    }
    if (self.type==4) {
        self.vcTitle=@"公司简介";
        textField.placeholder=@"请输入公司简介";
    }
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(40, 140, kWidth-80, 50)];
    [sureBtn setBackgroundColor:NavColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    // Do any additional setup after loading the view.
}
-(void)sureBtnAction
{
    if(self.type==1)
    {
        
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
