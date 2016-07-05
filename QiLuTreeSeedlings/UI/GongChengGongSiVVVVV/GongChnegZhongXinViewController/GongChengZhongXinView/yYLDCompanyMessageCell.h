//
//  yYLDCompanyMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDGCGSModel.h"
@interface yYLDCompanyMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (nonatomic,strong)YLDGCGSModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *logoV;
+(yYLDCompanyMessageCell *)yyldCompanyMessageCell;
@end
