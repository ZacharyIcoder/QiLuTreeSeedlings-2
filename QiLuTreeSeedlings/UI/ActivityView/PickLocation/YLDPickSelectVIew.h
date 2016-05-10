//
//  YLDPickSelectVIew.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@class YLDPickSelectVIew;
@protocol YLDPickSelectVIewDelegate <NSObject>

- (void)selectWithCtiyModel:(CityModel *)model andYLDPickSelectVIew:(YLDPickSelectVIew *)pickSelectVIew;

@end
@interface YLDPickSelectVIew : UIView
-(id)initWithFrame:(CGRect)frame andCode:(NSString *)code andLeve:(NSString *)leve;
@property (nonatomic,weak)id <YLDPickSelectVIewDelegate> delegate;
@end
