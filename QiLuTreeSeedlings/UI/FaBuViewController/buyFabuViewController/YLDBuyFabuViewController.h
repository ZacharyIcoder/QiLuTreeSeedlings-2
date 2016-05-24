//
//  YLDBuyFabuViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKArrowViewController.h"
@interface YLDBuyFabuViewController : ZIKArrowViewController
-(id)initWithUid:(NSString *)uid Withtitle:(NSString *)title WithName:(NSString *)name WithproductUid:(NSString *)productUid WithGuigeAry:(NSArray *)guigeAry;
-(id)initWithUid:(NSString *)uid Withtitle:(NSString *)title WithName:(NSString *)name WithproductUid:(NSString *)productUid WithGuigeAry:(NSArray *)guigeAry andBaseDic:(NSDictionary *)dic;
@end
