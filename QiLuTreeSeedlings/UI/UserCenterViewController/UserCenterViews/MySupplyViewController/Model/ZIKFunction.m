//
//  ZIKFunction.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKFunction.h"

@implementation ZIKFunction
#pragma mark - 设置TableView空行分割线隐藏
// 设置TableView空行分割线隐藏
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 字符串判空
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr  //字符串判空
{
    if (!parmStr) {
        return YES;
    }
    if ([parmStr isEqual:nil]) {
        return YES;
    }
    if ([parmStr isEqual:@""]) {
        return YES;
    }
    id tempStr=parmStr;
    if (tempStr==[NSNull null]) {
        return YES;
    }
    return NO;
}

#pragma mark - 计算指定时间与当前的时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSInteger temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",(long)temp];
    }

    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",(long)temp];
    }

    else if((temp = temp/24) <30){

        if (temp/7 < 1) {
            result = [NSString stringWithFormat:@"%ld天前",(long)temp];
        }
        else {
            result = [NSString stringWithFormat:@"%ld周前",(long)temp/7];
        }
    }

    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",(long)temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",(long)temp];
    }

    return  result;
}

#pragma mark - 时间转字符串
+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

#pragma  mark -  字符串转时间
+(NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}

@end
