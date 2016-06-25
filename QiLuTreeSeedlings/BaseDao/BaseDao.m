//
//  BaseDao.m
//  AKBOBADADrum
//
//  Created by Sarnath RD on 13-4-8.
//  Copyright (c) 2013年 Sarnath. All rights reserved.
//

#import "BaseDao.h"
#import "FileUtil.h"


@implementation BaseDao

@synthesize db;

//打开数据库
-(void)openDataBase{
	//获取doc目录
	//NSArray *paths=[[NSArray alloc] initWithArray: NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
	
	//NSString *docDir=[[NSString alloc] initWithString:[paths objectAtIndex:0]];
    NSString *dbPath = [FileUtil getDocumentPath:@"areadbs"];
	
	//设置数据库路径
//	NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"mydatabase" ofType:@""];
	
	//初始化FMDatabase对象
    //NSLog(@"%@",dbPath);
	self.db=[FMDatabase databaseWithPath:dbPath];
	
	//打开数据库
	[self.db open];
}

//开启事务
-(void) beginTransaction{
	[self.db beginTransaction];
}

//事务提交
-(void) transactionCommit{
	[self.db commit];
}

//事务回滚
-(void) transactionRollback{
	[self.db rollback];
}
//关闭数据库
- (void)closeDataBase{
	[self.db close];
}

//创建表
- (BOOL)executeUpdate:(NSString*) sql{
	BOOL result = [self.db executeUpdate:sql];
    return result;
}

//执行查询
- (FMResultSet*)executeQuery:(NSString*) sql{
	FMResultSet *rs=[self.db executeQuery:sql];
	return rs;
}
@end
