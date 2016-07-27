//
//  YLDShopJianJieViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/27.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDshopWareView.h"
@interface YLDShopJianJieViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet YLDshopWareView *wareView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
-(id)initWithMessage:(NSString *)str;
@end
