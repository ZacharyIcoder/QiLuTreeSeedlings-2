//
//  YLDZhanZhangMessageCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDZhanZhangDetialModel.h"
@protocol YLDZhanZhangMessageCellDelegate <NSObject>
-(void)backBtnAction:(UIButton *)sender;
-(void)showShopAcionWithUid:(NSString *)uid;
@end

@interface YLDZhanZhangMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titileLab;
@property (weak, nonatomic) IBOutlet UIImageView *UserImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *unkonwLab;
@property (nonatomic,strong)YLDZhanZhangDetialModel *model;
@property (nonatomic,weak) id<YLDZhanZhangMessageCellDelegate> delegate;
+(YLDZhanZhangMessageCell *)yldZhanZhangMessageCell;
- (IBAction)BackBtnAction:(UIButton *)sender;
@end
