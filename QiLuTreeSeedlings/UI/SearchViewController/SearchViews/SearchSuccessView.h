//
//  SearchSuccessView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@protocol SearchSuccessViewDelegatel <NSObject>

- (void)SearchSuccessViewPushBuyDetial:(NSString *)uid;
- (void)SearchSuccessViewPushSellDetial:(HotSellModel*)uid;
@end
@interface SearchSuccessView : UIView
@property (nonatomic,weak) id<SearchSuccessViewDelegatel> delegate;
@property (nonatomic) NSInteger searchType;
@property (nonatomic) NSInteger searchBAT;
@property (nonatomic,copy) NSString *searchStr;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong)NSArray *shaixuanAry;
@property (nonatomic,strong)NSString *City;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *county;
@property (nonatomic,strong)NSString *goldsupplier;
@property (nonatomic,strong)NSString *productUid;
-(void)searchViewActionWith:(NSString *)searchStr AndSearchType:(NSInteger)type;
-(void)searchViewActionWithSearchType:(NSInteger)type;
@end
