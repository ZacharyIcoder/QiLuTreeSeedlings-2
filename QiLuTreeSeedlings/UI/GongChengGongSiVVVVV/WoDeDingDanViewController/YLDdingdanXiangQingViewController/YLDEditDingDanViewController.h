//
//  YLDEditDingDanViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NomarBaseViewController.h"
@protocol YLDEditDingDanViewCdelegate<NSObject>
@optional
-(void)ddJJreload;
@end
@interface YLDEditDingDanViewController : NomarBaseViewController
@property (nonatomic,weak) id<YLDEditDingDanViewCdelegate> delegate;
-(id)initWithUid:(NSString *)uid;
@end
