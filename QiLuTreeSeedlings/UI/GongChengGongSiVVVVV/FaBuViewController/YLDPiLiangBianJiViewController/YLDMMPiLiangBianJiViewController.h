//
//  YLDMMPiLiangBianJiViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "NomarBaseViewController.h"
@protocol YLDMMeditingDelegate <NSObject>
@optional
-(void)finishActionWithAry:(NSMutableArray *)ary;
@end
@interface YLDMMPiLiangBianJiViewController : NomarBaseViewController
@property (nonatomic,weak) id<YLDMMeditingDelegate> delegate;
-(id)initWithDataAry:(NSMutableArray *)dataAry;
@end
