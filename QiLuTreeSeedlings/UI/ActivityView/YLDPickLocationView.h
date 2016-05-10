//
//  YLDPickLocationView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
@protocol YLDPickLocationDelegate <NSObject>
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen;
@end
@interface YLDPickLocationView : UIView
@property (nonatomic,weak) id <YLDPickLocationDelegate>delegate;
-(id)initWithFrame:(CGRect)frame;
-(void)showPickView;
-(void)removePickView;
@end
