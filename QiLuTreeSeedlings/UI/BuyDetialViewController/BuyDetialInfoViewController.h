//
//  BuyDetialInfoViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKCustomizedInfoListModel.h"
@interface BuyDetialInfoViewController : UIViewController
//@property (nonatomic, assign) BOOL isCaiGou;
-(id)initWithSaercherInfo:(NSString *)uid;
-(id)initWithDingzhiModel:(ZIKCustomizedInfoListModel *)model;
-(id)initMyDetialWithSaercherInfo:(NSString *)uid;
-(id)initWithCaiGouModel:(ZIKCustomizedInfoListModel *)model;

-(id)initWithHeZuoMiaoQiInfo:(NSString *)uid;

@end
