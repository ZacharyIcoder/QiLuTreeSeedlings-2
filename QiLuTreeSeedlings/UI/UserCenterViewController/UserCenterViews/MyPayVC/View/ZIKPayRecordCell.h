//
//  ZIKPayRecordCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/27.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKConsumeRecordFrame;
@interface ZIKPayRecordCell : UITableViewCell
@property (nonatomic, strong) ZIKConsumeRecordFrame *recordFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
