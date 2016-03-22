//
//  BaseDao.h
//  AKBOBADADrum
//
//  Created by Sarnath RD on 13-4-8.
//  Copyright (c) 2013年 Sarnath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface BaseDao : NSObject

//数据库句柄
@property (nonatomic,strong) FMDatabase *db;

//打开数据库
-(void)openDataBase;

//关闭数据库
- (void)closeDataBase;

//开启事务
-(void) beginTransaction;

//事务提交
-(void) transactionCommit;

//事务回滚
-(void) transactionRollback;

//执行数据局增，删，改操作
- (BOOL)executeUpdate:(NSString*) sql;

//执行查询
- (FMResultSet*)executeQuery:(NSString*) sql;

@end
