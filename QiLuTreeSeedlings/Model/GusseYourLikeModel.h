//
//  GusseYourLikeModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GusseYourLikeModel : NSObject
@property (nonatomic) int ifNew;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *prductUid;
@property (nonatomic) int type;
+(GusseYourLikeModel *)creatGusseYoutLikeBy:(NSDictionary *)dic;
+(NSArray *)creatGusseLikeAryByAry:(NSArray *)ary;
@end
