//
//  YLDKeFuTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLDKeFuTableViewCellDelegate <NSObject>
- (void)senderMessageWithDic:(NSDictionary *)dic;
@end
@interface YLDKeFuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,strong)NSDictionary *messageDic;
@property (nonatomic,weak) id<YLDKeFuTableViewCellDelegate>delegate;
+(YLDKeFuTableViewCell *)yldKeFuTableViewCell;
@end
