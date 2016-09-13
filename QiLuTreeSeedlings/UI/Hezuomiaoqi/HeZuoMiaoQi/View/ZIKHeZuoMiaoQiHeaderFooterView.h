//
//  ZIKHeZuoMiaoQiHeaderFooterView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MoreButtonBlock)(NSInteger indexPath);

@interface ZIKHeZuoMiaoQiHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, assign) NSInteger starNum;

@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, copy) MoreButtonBlock moreButtonBlock;

@end
