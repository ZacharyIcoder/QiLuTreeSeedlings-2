//
//  SupplyDetialMode.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyDetialMode : NSObject
@property (nonatomic,strong)NSString *address;
@property (nonatomic       )NSInteger collect;
@property (nonatomic,strong)NSString *collectUid;
@property (nonatomic,strong)NSString *count;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *descriptions;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic       )NSInteger dataState;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *spec;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *supplybuyName;
@property (nonatomic,strong)NSString *supplybuyUid;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *views;
@property (nonatomic)       NSInteger state;
@property (nonatomic,strong)NSString *productName;

@property (nonatomic, copy) NSString *memberPhone;
@property (nonatomic, copy) NSString *memberName;
//1金，2银，3铜
@property (nonatomic) NSInteger goldsupplier;
/**
 *  苗圃Uid
 */
@property (nonatomic, copy) NSString *nurseryUid;//苗圃Uid
///**
// *  店铺信息时使用
// */
//@property (nonatomic, copy) NSString *memberUid;
//@property (nonatomic, copy) NSString *state;
+(SupplyDetialMode *)creatSupplyDetialModelByDic:(NSDictionary *)dic;
@end
