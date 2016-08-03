//
//  ZIKQiugouMoreShareView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/3.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZIKQiugouMoreShareViewDelegate <NSObject>

@required
-(void)sendTimeInfo:(NSString *)timeStr;

@end
@interface ZIKQiugouMoreShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, assign) id<ZIKQiugouMoreShareViewDelegate>delegate;
+(ZIKQiugouMoreShareView *)instanceShowShareView;
@end
