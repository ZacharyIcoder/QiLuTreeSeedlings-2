//
//  PickerShowView.h
//  baba88
//
//  Created by JCAI on 15/7/22.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerShowView;
@protocol PickeShowDelegate <NSObject>

@optional
-(void)selectNum:(NSInteger)select andselectInfo:(NSString *)selectStr;
- (void)selectNum:(NSInteger)select;
- (void)selectInfo:(NSString *)select;
-(void)selectNum:(NSInteger)select andselectInfo:(NSString *)selectStr PickerShowView:(PickerShowView*)pickerShowView;
@end

@interface PickerShowView : UIView 
@property (nonatomic,  strong) UIPickerView *pickerView;
@property (nonatomic) id<PickeShowDelegate> delegate;


- (void)resetPickerData:(NSArray *)datasArray;
- (void)resetPickerData:(NSArray *)datasArray andRow:(NSInteger)row;
- (void)showInView;
-(void)dismiss;

@end
