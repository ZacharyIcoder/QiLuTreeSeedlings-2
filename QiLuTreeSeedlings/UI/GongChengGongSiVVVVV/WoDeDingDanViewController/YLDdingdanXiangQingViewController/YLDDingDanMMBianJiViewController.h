//
//  YLDDingDanMMBianJiViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "NomarBaseViewController.h"
@protocol YLDDingDanMMBianJiViewCdelegate <NSObject>
@optional
-(void)MMreload;
@end;
@interface YLDDingDanMMBianJiViewController : NomarBaseViewController
@property (nonatomic,weak)id <YLDDingDanMMBianJiViewCdelegate> delegate;
-(id)initWithUid:(NSString *)uid;
@end
