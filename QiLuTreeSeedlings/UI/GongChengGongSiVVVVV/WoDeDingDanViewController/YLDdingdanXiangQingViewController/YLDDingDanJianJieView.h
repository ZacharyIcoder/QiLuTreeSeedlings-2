//
//  YLDDingDanJianJieView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDDingDanDetialModel.h"
#import "YLDHeZuoDetial.h"
@interface YLDDingDanJianJieView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dingdanTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *baojiaTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiliangLab;
@property (weak, nonatomic) IBOutlet UILabel *ciliangLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong,nonatomic)YLDDingDanDetialModel *model;
@property (strong,nonatomic)YLDHeZuoDetial *hezuomodel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *celiangHeight;
@property (weak, nonatomic) IBOutlet UITextView *shuomingTextField;
+(YLDDingDanJianJieView *)yldDingDanJianJieView;
@end
