//
//  UserInfoModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic,copy) NSString *access_id;
@property (nonatomic,copy) NSString *access_token;
@property (nonatomic,copy) NSString * goldsupplier;
@property (nonatomic)        NSInteger goldsupplierStatus;
@property (nonatomic)        NSInteger isworkstation;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *balance;
@property (nonatomic,copy) NSString *count;
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *workstationUId;
@property (nonatomic,copy) NSString *sumscore;
@property (nonatomic,copy) NSString *noReadCount;
@property (nonatomic,copy) NSString *nrMessageCount;
@property (nonatomic) NSInteger projectCompanyStatus;
@property (nonatomic,copy) NSString *brief;
+(UserInfoModel *)userInfoCreatByDic:(NSDictionary *)dic;
-(void)reloadInfoByDic:(NSDictionary *)dic;
@end
