//
//  FileUtil.m
//  APP
//
//  Created by iOSdev on 14-2-17.
//  Copyright (c) 2014年 SarnathAir. All rights reserved.
//

#import "FileUtil.h"
@implementation FileUtil


/**
 * @description 获取文件夹路径，不存在的话自动创建， ！此方法只针对Document下的目录
 * @param
 *     dirName - 目录名称
 * @return
 *     目录的路径
 */
+(NSString *)getDirectoryPath:(NSString*)dirName
{
	//文件管理器
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	//document目录
	NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	//要创建文件夹的完整目录
	NSString *dir = [doc stringByAppendingPathComponent:dirName];
	
	//是否存在
	BOOL isExist = YES;
	
	//判断是否存在
	if(!([fileManager fileExistsAtPath:dir isDirectory:&isExist]&&isExist))
	{
		NSError *error=nil;
        
		//如果不存在，就创建
		if([fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error]==NO)
		{
            //创建失败
			//CLog(@"folder create is fail!");
			
		}
	}
    return dir;
}


+(NSString *)getDocumentPath:(NSString*)fileName
{
    //文件管理器
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    //document目录
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //要创建文件夹的完整目录
    NSString *dir = [doc stringByAppendingPathComponent:fileName];
    
    //是否存在
    BOOL isExist = YES;
    
    //判断是否存在
    if(!([fileManager fileExistsAtPath:dir isDirectory:&isExist]))
    {
        return @"";
    }
    return dir;
}

/**
 *  获取文件大小
 *
 *  @param fullFile 文件路纪念馆
 *
 *  @return
 */
+(NSString *)getFileSize:(NSString *)fullFile
{
    // 取文件大小
    NSError *error = nil;
    NSDictionary* dictFile = [[NSFileManager defaultManager] attributesOfItemAtPath:fullFile error:&error];
    if (error)
    {
//        CLog(@"getfilesize error: %@", error);
        return @"0";
    }
    unsigned long long nFileSize = [dictFile fileSize]; //得到文件大小
    return [NSString stringWithFormat:@"%lld",nFileSize];
}



@end
