//
//  UserInfoModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic,strong) NSString *access_id;
@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *goldsupplier;
@property (nonatomic)        NSInteger isworkstation;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *balance;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *headUrl;
@property (nonatomic,strong) NSString *workstationUId;
@property (nonatomic,strong) NSString *sumscore;
@property (nonatomic,strong) NSString *noReadCount;
@property (nonatomic,strong) NSString *nrMessageCount;
+(UserInfoModel *)userInfoCreatByDic:(NSDictionary *)dic;
-(void)reloadInfoByDic:(NSDictionary *)dic;
@end
