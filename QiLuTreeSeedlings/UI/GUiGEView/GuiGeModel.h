//
//  GuiGeModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Propers;
@interface GuiGeModel : NSObject
@property (nonatomic,copy) NSString *alert;
@property (nonatomic) NSInteger check;
@property (nonatomic) NSInteger main;
@property (nonatomic,copy) NSString *name;
@property (nonatomic) NSInteger sort;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *answer;
@property (nonatomic) NSInteger level;
@property (nonatomic,strong)NSMutableArray *answerAry;
@property (nonatomic,strong)NSArray *values;
@property (nonatomic,strong) GuiGeModel *sonModel;
@property (nonatomic,strong) Propers *selectProper;
@property (nonatomic,strong) NSMutableArray *propertyLists;
@property (nonatomic,copy) NSString *keyStr1;
@property (nonatomic,copy) NSString *keyStr2;
@property (nonatomic,copy) NSString *keyStr3;
+(GuiGeModel *)creatGuiGeModelWithDic:(NSDictionary *)dic;
@end
@interface Propers : NSObject
@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger operation;
@property (nonatomic) NSInteger range;
@property (nonatomic,copy) NSString *relation;
@property (nonatomic,copy) NSString *relationName;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *numberType;
@property (nonatomic,strong)GuiGeModel *guanlianModel;
-(id)initWithDic:(NSDictionary *)dic;
@end