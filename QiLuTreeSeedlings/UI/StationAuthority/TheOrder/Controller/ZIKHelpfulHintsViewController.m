//
//  ZIKHelpfulHintsViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHelpfulHintsViewController.h"

@interface ZIKHelpfulHintsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@end

@implementation ZIKHelpfulHintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"友情提示";
    self.sureButton.backgroundColor = NavColor;
}

- (IBAction)telePhoneButtonClick:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://4007088369"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)sureButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
