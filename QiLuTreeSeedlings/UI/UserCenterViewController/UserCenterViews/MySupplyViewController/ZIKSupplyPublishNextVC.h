//
//  ZIKSupplyPublishNextVC.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "ZIKMySupplyCreateModel.h"
#import "ZIKPickImageView.h"
@interface ZIKSupplyPublishNextVC : ZIKArrowViewController
@property (nonatomic, strong) ZIKMySupplyCreateModel *supplyModel;
@property (nonatomic, weak  ) ZIKPickImageView *pickerImgView;
-(id)initWithNurseryList:(NSArray *)nurseryAry WithbaseMsg:(NSDictionary *)baseDic;
@end
