//
//  LYDShopAddressViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/27.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextField.h"
@interface LYDShopAddressViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet YLDRangeTextField *addressTextField;
-(id)initWithshopProvince:(NSString *)shopProvince withshopCity:(NSString *)shopCity withshopCounty:(NSString *)shopCounty withshopAddress:(NSString *)shopAddress WithareaAddress:(NSString *)areaAddress;
@end
