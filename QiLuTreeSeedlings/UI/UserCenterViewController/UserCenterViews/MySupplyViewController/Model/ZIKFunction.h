//
//  ZIKFunction.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZIKFunction : NSObject
/**
 *  设置TableView空行分割线隐藏
 *
 *  @param tableView tableView description
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
/**
 *  字符串判空
 *
 *  @param parmStr 字符串
 *
 *  @return BOOL(YES:空 NO:非空)
 */
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr;   //字符串判空
/**
 *  与当前时间做比较
 *
 *  @param compareDate compareDate description
 *
 *  @return 时间差【多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)】
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
/**
 *  字符串转时间
 *
 *  @param date date description
 *
 *  @return 时间字符串
 */
+(NSString*)getStringFromDate:(NSDate*)date;
/**
 *  时间转字符串
 *
 *  @param dateString dateString description
 *
 *  @return 时间NSDate格式
 */
+(NSDate *)getDateFromString:(NSString *)dateString;
+ (NSString *)weixinPayWithOrderID:(NSString *)orderID;
+ (void)zhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId;
+ (NSString *)generateTradeNO;
@end
