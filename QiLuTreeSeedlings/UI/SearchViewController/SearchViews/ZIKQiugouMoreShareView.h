//
//  ZIKQiugouMoreShareView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/3.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKQiugouMoreShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
+(ZIKQiugouMoreShareView *)instanceShowShareView;
@end
