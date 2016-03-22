//
//  DataCache.m
//
//  Created by WeiShi on 14/10/22.
//  Copyright (c) 2014年 Mr.Hou. All rights reserved.
//
#import "NSString+MD5.h"
#import "DataCache.h"
static DataCache * _dataCache;

@implementation DataCache

+ (DataCache *)shareDateCache
{
    if (_dataCache == nil) {
        _dataCache = [[DataCache alloc]init];
    }
    return _dataCache;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _dataCache = [super allocWithZone:zone];
    });
    return _dataCache;

}

- (instancetype)init
{
    if (self = [super init]) {
        _myTime = 30;
    }
    return self;
}

- (void)saveWithData:(NSData *)data path:(NSString *)path
{
//获取缓存路径
    NSString * cachePath = [NSString stringWithFormat:@"%@/Documents/Cache/", NSHomeDirectory()];
    path = [path MD5Hash];
    NSString * filePath = [NSString stringWithFormat:@"%@%@", cachePath, path];
    BOOL isWrite = [data writeToFile:filePath atomically:YES];
    if (isWrite) {
        float cacheSize = [self folderSizeAtPath:cachePath];
        [self.delegate readCacheSize:cacheSize];
    }else
    {
        return;
    }

}
- (NSData *)getDataWithPath:(NSString *)path
{
    path = [path MD5Hash];
     NSString * filePath = [NSString stringWithFormat:@"%@/Documents/Cache/%@", NSHomeDirectory(), path];
    NSFileManager * fileManger = [NSFileManager defaultManager];

    if (![fileManger fileExistsAtPath:filePath]) {
        return nil;
    }
    NSDictionary * dict = [fileManger attributesOfItemAtPath:filePath error:nil];
    NSDate * lastDate = dict[NSFileModificationDate];
    NSTimeInterval difTime = [[NSDate date] timeIntervalSinceDate:lastDate];
    if (_myTime < difTime) {
        return nil;
    }
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

- (long long)getDataCacheSize:(NSString *)path
{
    NSString * Path = [NSString stringWithFormat:@"%@", path];
    NSFileManager * manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:Path]) {
        NSDictionary *fileDic = [manger attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        
         return size;
    }else
    {
        return 0;
    }
   

//    if ([manger fileExistsAtPath:Path]) {
//        long long size = [manger attributesOfItemAtPath:path error:nil].fileSize;
//        return size;
//    }else
//    { return 0;
//    }

}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self getDataCacheSize:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (void)clearCache:(NSString *)path
{
    NSFileManager * manger = [NSFileManager defaultManager];
    
    if ([manger fileExistsAtPath:path]) {
        NSArray * childerFiles = [manger subpathsAtPath:path];
        for (NSString * fileName in childerFiles) {
            NSString * ansolutePath = [path stringByAppendingPathComponent:fileName];
            [manger removeItemAtPath:ansolutePath error:nil];
        }
       
        [self.delegate readCacheSize:[self folderSizeAtPath:path]];
     
    }
    
    

}

@end
