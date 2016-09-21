//
//  ZIKHelpfulHintsViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHelpfulHintsViewController.h"

@interface ZIKHelpfulHintsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstHintLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondHintLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation ZIKHelpfulHintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"友情提示";
    self.sureButton.backgroundColor = NavColor;
    if ([self.qubie isEqualToString:@"苗企中心"]) {
        self.firstHintLabel.text  = @"抱歉您不是齐鲁苗木网合作苗企,无法进入苗企中心";
        self.secondHintLabel.text = @"如果您希望成为合作苗企，请联系客服";
    }
    if ([self.qubie isEqualToString:@"金牌中心"]) {
        self.firstHintLabel.text  = @"抱歉您不是齐鲁苗木网金牌供应商,无法进入此功能";
        self.secondHintLabel.text = @"如果您希望成为金牌供应商，请联系客服";
    }
    if ([self.qubie isEqualToString:@"站长中心"]) {
        self.firstHintLabel.text  = @"抱歉您不是齐鲁苗木网工作站站长,暂时无法使用站长通功能";
        self.secondHintLabel.text = @"如果您希望成为工作站站长，请联系客服";
    }
}

- (IBAction)telePhoneButtonClick:(id)sender {
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://4007088369"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)sureButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
