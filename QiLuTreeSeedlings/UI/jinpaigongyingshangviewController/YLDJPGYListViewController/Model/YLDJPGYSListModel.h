//
//  YLDJPGYSListModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "areaall": "山东省枣庄市",               地址
//    "companyName": "朱玉晓企业",             供应商名称
//    "goldsupplier": 1,                       身份标识 1jin 2yin 3tong
//    "name": "18263968677",                   联系人
//    "phone": "18263968677",                  电话
//    "uid": "9367AA68-5B37-4BF5-93EB-BFD3E6B9D50D"
//}
@interface YLDJPGYSListModel : NSObject
@property (nonatomic,copy) NSString *areaall;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,assign) NSInteger goldsupplier;
+(YLDJPGYSListModel *)modelByDic:(NSDictionary *)dic;
+(NSMutableArray *)aryByAry:(NSArray *)ary;
@end
