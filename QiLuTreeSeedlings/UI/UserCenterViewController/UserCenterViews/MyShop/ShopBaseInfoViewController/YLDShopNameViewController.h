//
//  YLDShopNameViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/26.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextView.h"
#import "YLDshopWareView.h"
@interface YLDShopNameViewController : ZIKArrowViewController
@property (weak, nonatomic)  YLDRangeTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet YLDshopWareView *wareView; 
-(id)initWithMessage:(NSString *)str;
@end
