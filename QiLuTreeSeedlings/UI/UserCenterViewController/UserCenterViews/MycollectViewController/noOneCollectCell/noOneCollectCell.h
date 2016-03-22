//
//  noOneCollectCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/12.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noOneCollectCell : UITableViewCell
@property (nonatomic)NSInteger type;
@property (nonatomic,strong)UIButton *actionBtn;
-(id)initWithFrame:(CGRect)frame andType:(NSInteger)type;
@end
