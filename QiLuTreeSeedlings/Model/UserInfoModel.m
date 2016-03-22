//
//  UserInfoModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+(UserInfoModel *)userInfoCreatByDic:(NSDictionary *)dic
{
    UserInfoModel *model=[[UserInfoModel alloc]init];
    model.access_id=[dic objectForKey:@"access_id"];
    model.access_token=[dic objectForKey:@"access_token"];
    model.goldsupplier=[dic objectForKey:@"goldsupplier"];
    model.isworkstation=[[dic objectForKey:@"isworkstation"] integerValue];
    model.name=[dic objectForKey:@"name"];
    model.phone=[dic objectForKey:@"phone"];
    return model;
}
-(void)reloadInfoByDic:(NSDictionary *)dic
{
    self.balance=[dic objectForKey:@"balance"];
    self.count=[dic objectForKey:@"count"];
    self.goldsupplier=[dic objectForKey:@"goldsupplier"];
    self.isworkstation=[[dic objectForKey:@"isworkstation"] integerValue];
    self.name=[dic objectForKey:@"name"];
    self.phone=[dic objectForKey:@"phone"];
    self.sumscore=[dic objectForKey:@"sumscore"];
    self.noReadCount=[dic objectForKey:@"noReadCount"];
    NSString *headUrl=[dic objectForKey:@"headUrl"];
    if (headUrl) {
        self.headUrl=headUrl;
    }
    else
    {
        headUrl=@"";
    }
    self.headUrl=headUrl;
}
@end
