//
//  YLDJPGYSDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSDetialViewController.h"
#import "HttpClient.h"
@interface YLDJPGYSDetialViewController ()
@property (nonatomic,copy)NSString *uid;
@end

@implementation YLDJPGYSDetialViewController
-(id)initWithUid:(NSString *)memberUid
{
    self=[super init];
    if (self) {
        self.uid=memberUid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
