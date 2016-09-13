//
//  ZIKMiaoQiDetailHeaderFooterView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailHeaderFooterView.h"
#import "ZIKMiaoQiDetailModel.h"
@interface ZIKMiaoQiDetailHeaderFooterView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@end
@implementation ZIKMiaoQiDetailHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configWithModel:(ZIKMiaoQiDetailModel *)model {
    self.companyNameLabel.text = model.companyName;
    self.briefLabel.text = model.name;
}

- (IBAction)backButtonClick:(id)sender {
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiDetailBackHome" object:nil];
}
@end
