//
//  YLDPickTimeView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDPickTimeDelegate <NSObject>

@optional
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr;
@end
@interface YLDPickTimeView : UIView
@property (nonatomic,  strong) UIDatePicker *pickerView;
@property (nonatomic) id<YLDPickTimeDelegate> delegate;
@property (nonatomic,strong) NSDate *selectDate;
@property (nonatomic, copy) NSString *type;//0,默认;1,求购列表多条分享选择时间;
- (void)showInView;
@end
