//
//  ZHPickerBtn.h
//  ZhenHao
//
//  Created by Apple on 15/10/22.
//  Copyright © 2015年 ShanDongSanMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHPickerBtn;

@protocol ZHPickerBtnDeleteDelegate <NSObject>

- (void)pickBtnDelete:(ZHPickerBtn * )pickBtn;

@end


@interface ZHPickerBtn : UIButton

@property(nonatomic, assign) id<ZHPickerBtnDeleteDelegate> deleteDelegate;

@end
