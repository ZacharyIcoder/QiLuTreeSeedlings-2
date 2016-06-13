//
//  YLDHelpDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHelpDetialViewController.h"

@interface YLDHelpDetialViewController ()
@property (nonatomic,strong) NSDictionary *dic;
@end

@implementation YLDHelpDetialViewController
-(id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.dic=dic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=[self.dic objectForKey:@"title"];
    NSString *path = [self.dic objectForKey:@"link"];
    NSURL *url = [[NSURL alloc] initWithString:path];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view.
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
