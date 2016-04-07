//
//  IntegraTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "IntegraTableViewCell.h"
@interface IntegraTableViewCell ()
//@property (nonatomic)
@end
@implementation IntegraTableViewCell
+(NSString *)IDStr
{
    return @"IntegraTableViewCell";
}
-(id)init
{
    self=[super init];
    if (self) {
        [self setRestorationIdentifier:@"IntegraTableViewCell"];
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
