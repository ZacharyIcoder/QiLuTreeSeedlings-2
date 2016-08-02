//
//  YLDShopPhoneViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/27.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopPhoneViewController.h"
#import "YLDRangeTextView.h"
@interface YLDShopPhoneViewController ()
@property (weak, nonatomic)  YLDRangeTextView *textView;
@property (nonatomic,copy)NSString *str;
@end

@implementation YLDShopPhoneViewController
-(id)initWithMessage:(NSString *)str
{
    self=[super init];
    if (self) {
        self.str=str;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"联系方式";
    YLDRangeTextView *textView=[[YLDRangeTextView alloc]initWithFrame:CGRectMake(0, 70, kWidth, 100)];
    [textView setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:textView];
    self.textView=textView;
    textView.text=self.str;
    textView.rangeNumber=11;
    textView.placeholder=@"请输入联系方式";
    textView.keyboardType=UIKeyboardTypeNumberPad;
    [self.wareBtn addTextWithAry:@[@"1、固定电话或移动电话"]];
    // Do any additional setup after loading the view from its nib.
    [self.sureBtn addTarget:self action:@selector(sureBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)sureBtnAcion
{
  if(self.textView.text.length!=11)
    {
        [ToastView showTopToast:@"请输入11位电话"];
        return;
    }
    
    
    [HTTPCLIENT getMyShopBaseMessageUpDataWithType:@"4" value:self.textView.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"修改成功，即将返回"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
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
