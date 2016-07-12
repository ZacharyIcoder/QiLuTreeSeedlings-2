//
//  ZIKWorkstationSelectView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZIKWorkstationSelectViewDelegate <NSObject>
@optional

- (void)didSelector:(NSString *)selectId title:(NSString *)selectTitle level:(NSString *)level;

@end

@interface ZIKWorkstationSelectView : UIView
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *countryCode;

@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) id<ZIKWorkstationSelectViewDelegate>delegate;
+(ZIKWorkstationSelectView *)instanceSelectAreaView;
@end
