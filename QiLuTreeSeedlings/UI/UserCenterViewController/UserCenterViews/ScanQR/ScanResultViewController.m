//
//  BusinessesViewController.m
//  WiFiManger
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//


#import "ScanResultViewController.h"
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

#define ScreenHeight ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.height - 20))
//获取屏幕宽跟高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ScanResultViewController ()
{
    UIWebView *bunessWeb;
}
@property (nonatomic,retain) UIActivityIndicatorView *activity;
@end

@implementation ScanResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

//        self.tabBarController.tabBar.hidden = YES;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor orangeColor];
  
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    [self setTitleBar];
    
    bunessWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-20+5)];
    
    
    bunessWeb.delegate = self;
    bunessWeb.contentMode = UIViewContentModeScaleAspectFit;
   
    [self.view addSubview:bunessWeb];
    
    
    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0, ScreenHeight/2.0, 10, 10)];
    //bunessWeb.backgroundColor = [UIColor orangeColor];
    _activity.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    [bunessWeb addSubview:_activity];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];//创建NSURLRequest
    [bunessWeb loadRequest:request];//加载
    
   
   
    
    
    //导航
//    [self.view setBackgroundColor:BB_Back_Color_Here];
//    [self.navigationItem setLeftItemWithTarget:self action:@selector(leftbtnPressed:) image:@"返回.png" imageH:@"返回-点击.png"];
}
- (void)leftbtnPressed:(UIButton*)btn
{
    if ([self.resquestType isEqualToString:@"saoyisao"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}




- (void)setTitleBar
{
    
   
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2, 0, 200, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"DamascusMedium" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.busnessName;
    self.navigationItem.titleView = titleLabel;
    
   
    
}









#pragma mark - UIWebviewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activity startAnimating];
    //NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    NSString *ulrStr = [webView.request.URL absoluteString];
     NSLog(@"%@",ulrStr);

    

    
    
    [_activity stopAnimating];
    [_activity removeFromSuperview];

}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"加载出差");
}

-(void)viewDidDisappear:(BOOL)animated
{
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
