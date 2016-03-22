//
//  QLsearchView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QLSearchViewDelegate <NSObject>
@optional
-(void)searchActionWithDic:(NSDictionary *)dic;
@end
@interface QLsearchView : UIView
@property (nonatomic,weak) id<QLSearchViewDelegate> delegate;

@end
