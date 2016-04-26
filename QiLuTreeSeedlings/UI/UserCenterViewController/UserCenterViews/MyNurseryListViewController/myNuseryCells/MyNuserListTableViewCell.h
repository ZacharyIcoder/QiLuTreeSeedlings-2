//
//  MyNuserListTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NurseryModel.h"
@interface MyNuserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UIIV1;
@property (weak, nonatomic) IBOutlet UIImageView *UIIV2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *chargelPersonLab;
@property (nonatomic,strong) NurseryModel *model;
@property (nonatomic) BOOL isSelect;
+(NSString *)IdStr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
