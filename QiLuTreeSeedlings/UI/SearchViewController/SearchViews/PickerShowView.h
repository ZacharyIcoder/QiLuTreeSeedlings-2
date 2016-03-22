//
//  PickerShowView.h
//  baba88
//
//  Created by JCAI on 15/7/22.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickeShowDelegate <NSObject>

@optional
- (void)selectInfo:(NSString *)select;
- (void)selectNum:(NSInteger)select;
@end

@interface PickerShowView : UIView 

@property (nonatomic) id<PickeShowDelegate> delegate;


- (void)resetPickerData:(NSArray *)datasArray;
- (void)resetPickerData:(NSArray *)datasArray andRow:(NSInteger)row;
- (void)showInView;
-(void)dismiss;

@end
