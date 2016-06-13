//
//  YLDKeFuTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDKeFuTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "UIDefines.h"
@interface YLDKeFuTableViewCell()<MFMessageComposeViewControllerDelegate>
@end
@implementation YLDKeFuTableViewCell
+(YLDKeFuTableViewCell *)yldKeFuTableViewCell
{
    YLDKeFuTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDKeFuTableViewCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@""];
    //NSLog(@"str======%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{
    //    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"sms://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
    //
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //[self showMessageView:[NSArray arrayWithObjects:[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"], nil] title:@"苗木求购" body:[NSString stringWithFormat:@"我对您在齐鲁苗木网APP发布的求购信息:%@ 很感兴趣",[[self.infoDic objectForKey:@"detail"] objectForKey:@"productName"]]];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            //[ToastView showToast:@"消息发送成功" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
        {
            //[ToastView showToast:@"消息发送失败" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
        {
            //[ToastView showToast:@"取消发送" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        default:
            break;
    }
//    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        // You can specify one or more preconfigured recipients.  The user has
        // the option to remove or add recipients from the message composer view
        // controller.
        picker.recipients = phones;
        
        // You can specify the initial message text that will appear in the message
        // composer view controller.
        picker.body = body;
        
       // [self presentViewController:picker animated:YES completion:NULL];
        [[[[picker viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
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
