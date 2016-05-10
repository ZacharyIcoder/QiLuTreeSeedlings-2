//
//  ZIKEmptyTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKEmptyTableViewCell.h"
#import "UIDefines.h"
@interface ZIKEmptyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@end
@implementation ZIKEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstLabel.textColor  = detialLabColor;
    self.secondLabel.textColor = detialLabColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEmptyImageNameStr:(NSString *)emptyImageNameStr {
    _emptyImageNameStr = emptyImageNameStr;
    self.emptyImageView.image = [UIImage imageNamed:_emptyImageNameStr];
}

- (void)setEmptyFirstStr:(NSString *)emptyFirstStr {
    _emptyImageNameStr = emptyFirstStr;
    self.firstLabel.text = _emptyFirstStr;
}

-(void)setEmpthSecondStr:(NSString *)empthSecondStr {
    _empthSecondStr = empthSecondStr;
    self.secondLabel.text = _empthSecondStr;
}
@end
