//
//  MyBuyListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/17.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "BuySearchTableViewCell.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
@interface MyBuyListViewController ()

@end

@implementation MyBuyListViewController
-(id)init
{
    self=[super init];
    if (self) {
        [HTTPCLIENT myBuyInfoListWtihPage:@"1" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                
            }
            else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
