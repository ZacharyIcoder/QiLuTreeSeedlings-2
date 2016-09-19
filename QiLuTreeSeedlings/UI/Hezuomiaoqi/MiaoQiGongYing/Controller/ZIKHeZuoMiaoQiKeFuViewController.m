//
//  ZIKHeZuoMiaoQiKeFuViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHeZuoMiaoQiKeFuViewController.h"
#import "EwenTextView.h"
#import "IQKeyboardManager.h"

@interface ZIKHeZuoMiaoQiKeFuViewController ()
@property (nonatomic, strong) EwenTextView *ewenTextView;

@end

@implementation ZIKHeZuoMiaoQiKeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)initUI{
    self.vcTitle = @"专属客服";
    self.leftBarBtnImgString = @"BackBtn";
//    self.leftBarBtnBlock = ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
//    };

    [self.view addSubview:self.ewenTextView];
}

- (EwenTextView *)ewenTextView{
    if (!_ewenTextView) {
        _ewenTextView = [[EwenTextView alloc]initWithFrame:CGRectMake(0, kHeight-49, kWidth, 49)];
        _ewenTextView.buttonText = @"发送";
        _ewenTextView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_ewenTextView setPlaceholderText:@"请输入问题"];
//        __weak typeof(self) weakSelf = self;//解决循环引用的问题
        _ewenTextView.EwenTextViewBlock = ^(NSString *test){
            CLog(@"%@",test);
//            [weakSelf requestPingLun:test];
        };
    }
    return _ewenTextView;
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
