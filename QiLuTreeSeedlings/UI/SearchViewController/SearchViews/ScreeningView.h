//
//  ScreeningView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScreeningViewDelegate <NSObject>

@optional
-(void)creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName;
@end
@interface ScreeningView : UIView
@property (nonatomic) NSInteger searchType;
@property (nonatomic,strong)NSString *City;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *county;
@property (nonatomic,strong)NSString *goldsupplier;
@property (nonatomic,strong)NSString *productUid;
@property (nonatomic,strong)NSString *productName;
@property (nonatomic,weak)id<ScreeningViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame andSearch:(NSString *)searchStr;
-(void)showViewAction;
@end
