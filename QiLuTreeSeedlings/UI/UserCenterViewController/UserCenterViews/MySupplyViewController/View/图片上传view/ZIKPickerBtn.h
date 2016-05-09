//
//  ZIKPickerBtn.h
//  SanMiKeJi
//
//  Created by Apple on 15/10/22.
//  Copyright © 2015年 SanMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZIKPickerBtn;

@protocol ZIKPickerBtnDeleteDelegate <NSObject>

- (void)pickBtnDelete:(ZIKPickerBtn * )pickBtn;

@end


@interface ZIKPickerBtn : UIButton

@property(nonatomic, assign) id<ZIKPickerBtnDeleteDelegate> deleteDelegate;
@property(nonatomic, strong) NSDictionary *urlDic;
@end