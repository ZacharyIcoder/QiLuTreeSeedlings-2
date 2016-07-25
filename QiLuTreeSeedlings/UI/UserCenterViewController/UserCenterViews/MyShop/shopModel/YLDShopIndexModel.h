//
//  YLDShopIndexModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDShopIndexModel : NSObject
@property (nonatomic,copy)NSString *goldsupplier;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger visitCount;
@property (nonatomic,copy) NSString *shopBackgroundUrl;
@property (nonatomic,copy) NSString *shopHeadUrl;
@property (nonatomic,assign) NSInteger creditMargin;
@property (nonatomic,assign) NSInteger visitDay;
@property (nonatomic,assign) NSInteger shareCount;
@property (nonatomic,assign)NSInteger goldsupplierflag;
+(YLDShopIndexModel *)yldShopIndexModelByDic:(NSDictionary *)dic;
@end
