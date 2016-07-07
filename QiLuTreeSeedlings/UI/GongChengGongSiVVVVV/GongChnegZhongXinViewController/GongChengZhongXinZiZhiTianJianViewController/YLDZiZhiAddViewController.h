//
//  YLDZiZhiAddViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NomarBaseViewController.h"
#import "GCZZModel.h"
@protocol YLDZiZhiAddDelegate <NSObject>
@optional
-(void)reloadViewWithModel:(GCZZModel *)model andDic:(NSMutableDictionary *)dic;
@end
@interface YLDZiZhiAddViewController : NomarBaseViewController
@property (nonatomic,weak) id<YLDZiZhiAddDelegate> delegate;
-(id)initWithType:(NSInteger)type;
-(id)initWithModel:(GCZZModel *)model andType:(NSInteger )type;
@end
