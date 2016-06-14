//
//  SettingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SettingViewController.h"
#import "AbountUsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "ToastView.h"
@interface SettingViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"设置";
     UIButton *yijianBTN=[self creatViewWithTitle:@"意见反馈" andY:70];
    [yijianBTN addTarget:self action:@selector(yijianfankuiBtn:) forControlEvents:UIControlEventTouchUpInside];
     UIButton *abuotUS = [self creatViewWithTitle:@"关于我们" andY:119.5];
    [abuotUS addTarget:self action:@selector(abountUSBtn:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)yijianfankuiBtn:(UIButton *)button
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (!mailViewController) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
//        NSLog(@"设备还没有添加邮件账户");
        [ToastView showTopToast:@"设备还没有添加邮件账户"];
        return;
    }
    mailViewController.mailComposeDelegate = self;
    [mailViewController setToRecipients:@[@"miaoxintongkefu@163.com"]];
    
    // 2.设置邮件主题
    [mailViewController setSubject:@"意见反馈"];
    
    // 3.设置邮件主体内容
    [mailViewController setMessageBody:@"意见反馈" isHTML:NO];
    
    // 4.添加附件
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Heaven Lake" ofType:@"jpg"];
   // NSData *attachmentData = [NSData dataWithContentsOfFile:imagePath];
   // [mailViewController addAttachmentData:attachmentData mimeType:@"image/jpeg" fileName:@"天堂之珠：仙本那"];
    
    // 5.呼出发送视图
    [self presentViewController:mailViewController animated:YES completion:nil];
//    button.backgroundColor = [UIColor lightGrayColor];
//    double delayInSeconds = 0.05;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        button.backgroundColor = [UIColor whiteColor];
//    });
//
//    UIAlertController *alertV= [UIAlertController alertControllerWithTitle:@"提示" message:@"感谢您的意见" preferredStyle:UIAlertControllerStyleAlert];
//    [alertV addTextFieldWithConfigurationHandler:^(UITextField *textField){
//        textField.placeholder = @"意见反馈";
//    }];
//
//    UIAlertAction *sellAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [ToastView showTopToast:@"感谢您的意见"];
//    }];
//    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alertV addAction:cancelAction];
//    [alertV addAction:sellAction];
//    
//    
//    [self presentViewController:alertV animated:YES completion:^{
//
//    }];

}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
           // NSLog(@"您已取消编辑");
            [ToastView showTopToast:@"您已取消编辑"];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
//            NSLog(@"邮件已保存");
            [ToastView showTopToast:@"邮件已保存"];
            break;
        case MFMailComposeResultSent: // 用户点击发送
//            NSLog(@"邮件发送成功");
            [ToastView showTopToast:@"邮件发送成功"];
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"发送失败");
            [ToastView showTopToast:@"发送失败"];
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)abountUSBtn:(UIButton *)button
{
    button.backgroundColor = [UIColor lightGrayColor];
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        button.backgroundColor = [UIColor whiteColor];
    });

    //NSLog(@"关于我们");
    AbountUsViewController *abountUnsVC=[[AbountUsViewController alloc]init];
    [self.navigationController pushViewController:abountUnsVC animated:YES];
}
-(UIButton *)creatViewWithTitle:(NSString *)title andY:(CGFloat)Y
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, Y, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.masksToBounds=YES;
    view.layer.borderColor=kLineColor.CGColor;
    view.layer.borderWidth=0.5;
    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [btn setTitleColor:detialLabColor forState:UIControlStateHighlighted];
    [view addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [self.view addSubview:view];
        return btn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
