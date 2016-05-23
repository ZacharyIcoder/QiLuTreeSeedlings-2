//
//  ZIKCityListViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "ZIKCitySectionHeaderView.h"
typedef NS_ENUM(NSInteger, SelectStyle) {
   SelectStyleSingleSelection = 0, //单选
   SelectStyleMultiSelect     = 1  //多选
};
@protocol ZIKCityListViewControllerDelegate;
@interface ZIKCityListViewController : ZIKRightBtnSringViewController<ZIKCitySectionHeaderViewDelegate>
@property (nonatomic) NSArray *citys;
@property (nonatomic) id <ZIKCityListViewControllerDelegate> delegate;
@property SelectStyle selectStyle;
@end

@protocol ZIKCityListViewControllerDelegate <NSObject>

@required
- (void)selectCitysInfo:(NSString *)citysStr;

@end

