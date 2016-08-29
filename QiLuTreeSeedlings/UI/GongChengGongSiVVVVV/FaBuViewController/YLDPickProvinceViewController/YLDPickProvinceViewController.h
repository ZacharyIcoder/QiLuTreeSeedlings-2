//
//  YLDPickProvinceViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/8/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "CityModel.h"
@protocol YLDPickProvinceControllerDelegate <NSObject>

//@required
///**
// *  地址选择必须实现方法
// *
// *  @param citysStr 选择的城市的code字符串
// */
//- (void)selectCitysInfo:(NSString *)citysStr;
@optional
-(void)selectCityModels:(NSMutableArray *)ary;

@end
@interface YLDPickProvinceViewController : ZIKRightBtnSringViewController
@property(nonatomic,weak)id<YLDPickProvinceControllerDelegate>delegate;
@property (nonatomic,strong)NSMutableArray *selectAry;
@end
