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
@end
