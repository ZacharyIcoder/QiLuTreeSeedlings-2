//
//  PickerLocation.h
//  baba88
//
//  Created by JCAI on 15/7/28.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Town : NSObject

@property (nonatomic,  strong) NSString *TownID;
@property (nonatomic,  strong) NSString *TownName;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
@end

@interface City : NSObject

@property (nonatomic,  strong) NSString *cityID;
@property (nonatomic,  strong) NSString *cityName;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
@property (nonatomic,  strong) NSMutableArray *towns;
@property (nonatomic,  strong) Town *selectedTowns;
@end

@interface Province : NSObject

@property (nonatomic,  strong) NSString *provinceID;
@property (nonatomic,  strong) NSString *provinceName;
@property (nonatomic,  strong) NSMutableArray *citys;
@property (nonatomic,  strong) City *selectedCity;
@property (nonatomic,  strong) NSString *code;
@property (nonatomic,  strong) NSString *parent_code;
@property (nonatomic,  strong) NSString *level;
@end


@protocol PickerLocationDelegate <NSObject>

- (void)selectedLocationInfo:(Province *)location;
//- (void)selectedLocationInfo:(Province *)location andCity:(City *)city;
@end

@interface PickerLocation : UIView

@property (nonatomic) id<PickerLocationDelegate> locationDelegate;

- (void)setLocation:(NSString *)province :(NSString *)city;

- (void)showInView;
-(void)dismiss;
@end
