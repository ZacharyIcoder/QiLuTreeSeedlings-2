//
//  ZIKHintTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKHintTableViewCell.h"
#import "UIDefines.h"
@interface ZIKHintTableViewCell ()

@end
@implementation ZIKHintTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hintLabel.textColor = yellowButtonColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHintStr:(NSString *)hintStr {
    _hintStr = hintStr;
    self.hintLabel.text = _hintStr;
}
@end
