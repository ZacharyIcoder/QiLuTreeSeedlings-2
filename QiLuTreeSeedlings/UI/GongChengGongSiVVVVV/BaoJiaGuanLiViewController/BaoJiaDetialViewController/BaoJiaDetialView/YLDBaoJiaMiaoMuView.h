//
//  YLDBaoJiaMiaoMuView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDBaoJiaMiaoMuModel.h"
@interface YLDBaoJiaMiaoMuView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiliangLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (nonatomic,strong)YLDBaoJiaMiaoMuModel *model;
@property (weak, nonatomic) IBOutlet UITextView *shuomingLab;
+(YLDBaoJiaMiaoMuView *)yldBaoJiaMiaoMuView;
@end
