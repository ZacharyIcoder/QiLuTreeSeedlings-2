//
//  YLDDingDanDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "NomarBaseViewController.h"
typedef enum
{
    weishenhe=0,
    baojiaozhong=1,
    yijieshu=2
    
}dingDanType;

@interface YLDDingDanDetialViewController : NomarBaseViewController
-(id)initWithUid:(NSString *)uid andType:(NSInteger)type;
@end
