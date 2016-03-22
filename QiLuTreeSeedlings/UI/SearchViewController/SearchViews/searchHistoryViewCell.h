//
//  searchHistoryViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchHistoryViewCell : UIView
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,strong)UIButton *deleteBtn;

-(id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)dic;
@end
