//
//  DataCache.h
//
//
//  Created by WeiShi on 14/10/22.
//  Copyright (c) 2014年 Mr.Hou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataCacheDelegate <NSObject>
/* 获取缓存的内存大小（以M为单位）*/
- (void)readCacheSize:(float)cacheSize;

@end

@interface DataCache : NSObject

@property (nonatomic, assign)NSTimeInterval myTime;
@property (nonatomic, strong)id<DataCacheDelegate>delegate;
@property (nonatomic, strong)void(^readCacheDataSize)(float cacheSize);

/*初始化单例*/
+ (DataCache *)shareDateCache;
/*保存数据到指定的路径下（路径只需要相对路径）*/
- (void)saveWithData:(NSData *)data path:(NSString *)path;
/*获取数据根据指定路径 (路径只需要相对路径)*/
- (NSData *)getDataWithPath:(NSString *)path;
/*获取缓存的数据内存*/
- (long long)getDataCacheSize:(NSString *)path;
/*清空路径下的文件*/
- (void)clearCache:(NSString *)path;

@end
