//
//  GetCityDao.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "GetCityDao.h"

@implementation GetCityDao
-(NSMutableArray *)getCityByLeve:(NSString *)str
{
    NSMutableArray *ary=[NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from area where level = %@",str];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
        [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        [ary addObject:dic];
    }
    
    return ary;
}
-(NSMutableArray *)getCityByLeve:(NSString *)str andParent_code:(NSString *)parent_code
{
    NSMutableArray *ary=[NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from area where level = %@ and parent_code like %@%",str,parent_code];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
         [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
         [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        [ary addObject:dic];
        
    }
    
    return ary;
}
-(NSString *)getCityNameByCityUid:(NSString *)uid
{
    NSString *str;
    
    NSString *sql = [NSString stringWithFormat:@"select name from area where code = %@",uid];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
       str = [frs stringForColumn:@"name"];
    }
    return str;
}
@end
