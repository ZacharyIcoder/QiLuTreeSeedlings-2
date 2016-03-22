//
//  FileUtil.h
//  APP
//
//  Created by iOSdev on 14-2-17.
//  Copyright (c) 2014年 SarnathAir. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FileUtil : NSObject

/**
 * @description 获取文件夹路径，不存在的话自动创建， ！此方法只针对Document下的目录
 * @param
 *     dirName - 目录名称
 * @return
 *     目录的路径
 */
+(NSString *)getDirectoryPath:(NSString*)dirName;

/**
 *  获取文件大小
 *
 *  @param fullFile 文件路纪念馆
 *
 *  @return
 */
+(NSString *)getFileSize:(NSString *)fullFile;

/**
 *  初始化数据库
 */


+(NSString *)getDocumentPath:(NSString*)fileName;

@end
