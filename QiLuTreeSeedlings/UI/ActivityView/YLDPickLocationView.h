//
//  YLDPickLocationView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
typedef enum {
    CityLeveSheng=1,//省
    CityLeveShi=2,//市
    CityLeveXian=3,//县
    CityLeveZhen=4,//镇
    
    
} CityLeve;
@protocol YLDPickLocationDelegate <NSObject>
-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen;
@end
@interface YLDPickLocationView : UIView
@property (nonatomic,weak) id <YLDPickLocationDelegate>delegate;
-(id)initWithFrame:(CGRect)frame CityLeve:(CityLeve)leve;
-(void)showPickView;
-(void)removePickView;
@end
