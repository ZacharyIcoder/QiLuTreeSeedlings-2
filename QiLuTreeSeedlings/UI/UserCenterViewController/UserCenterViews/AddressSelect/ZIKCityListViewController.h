//
//  ZIKCityListViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

#import "ZIKCitySectionHeaderView.h"
#import "GetCityDao.h"
#import "CityModel.h"
#import "ZIKCityModel.h"
typedef NS_ENUM(NSInteger, SelectStyle) {
   SelectStyleSingleSelection = 0, //单选
   SelectStyleMultiSelect     = 1  //多选
};

@protocol ZIKCityListViewControllerDelegate;

@interface ZIKCityListViewController : ZIKRightBtnSringViewController<ZIKCitySectionHeaderViewDelegate>

/**
 *  已选择的城市
 */
@property (nonatomic) NSArray *citys;
/**
 *  地址选择delegate
 */
@property (nonatomic) id <ZIKCityListViewControllerDelegate> delegate;
/**
 *  地址选择样式（单选，多选）（目前只要求多选）
 */
@property SelectStyle selectStyle;

@end

@protocol ZIKCityListViewControllerDelegate <NSObject>

@required
/**
 *  地址选择必须实现方法
 *
 *  @param citysStr 选择的城市的code字符串
 */
- (void)selectCitysInfo:(NSString *)citysStr;
@optional
-(void)selectCityModels:(NSArray *)ary;

@end

