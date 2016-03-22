//
//  TreeSpecificationsModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/4.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeSpecificationsModel : NSObject
@property (nonatomic,copy) NSString *alert;//提示语
@property (nonatomic) NSInteger dataType;//1：整数点；2小数点数字；3文本
@property (nonatomic,copy)NSString *defaultValue;
@property (nonatomic) NSInteger required;//1必填；0否
@property (nonatomic,copy)NSString *field;//苗木英文名
@property (nonatomic,copy)NSString *name;//苗木中文名
@property (nonatomic,copy)NSArray *optionList;//选项列表
@property (nonatomic)NSInteger optionType;//选项类型	1：单选按钮；2：复选框；3下拉
@property (nonatomic)NSInteger textLength;//输入文本长度
@property (nonatomic)NSInteger type;//规格类型；1：单行文本；2选项
@property (nonatomic,copy)NSString *unit;//单位
@property (nonatomic,copy) NSString *anwser;//用户选择
+(TreeSpecificationsModel *)creatTreeSpecificationsModelByDic:(NSDictionary *)dic;
+(NSArray *)creatTreeSpecificationsModelAryByAry:(NSArray *)ary;
@end
