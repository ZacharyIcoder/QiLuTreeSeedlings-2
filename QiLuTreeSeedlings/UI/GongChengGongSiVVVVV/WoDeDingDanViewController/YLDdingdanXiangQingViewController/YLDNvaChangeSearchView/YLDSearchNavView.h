//
//  YLDSearchNavView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDSearchNavViewDelegate <NSObject>
@optional
-(void)hidingAction;
@end
@interface YLDSearchNavView : UIView
@property (nonatomic,weak) id<YLDSearchNavViewDelegate> delegate;
@end
