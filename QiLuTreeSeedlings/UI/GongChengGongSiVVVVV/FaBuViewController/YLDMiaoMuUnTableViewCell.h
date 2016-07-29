//
//  YLDMiaoMuUnTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDMiaoMuUnTableViewCellDelegate <NSObject>
@optional
-(void)chakanActionWithTag:(NSInteger)tag andDic:(NSDictionary *)dic;
@end
@interface YLDMiaoMuUnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *jieshaoLab;
@property (nonatomic,strong) UIButton *chakanBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) NSDictionary *messageDic;
@property (nonatomic,weak)id<YLDMiaoMuUnTableViewCellDelegate> delegate;
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell;
+(YLDMiaoMuUnTableViewCell *)yldMiaoMuUnTableViewCell2;
@end
