//
//  ZIKMiaoQiDetailHeaderFooterView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailHeaderFooterView.h"
#import "ZIKMiaoQiDetailModel.h"
#import "UIImageView+AFNetworking.h"

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
    self.companyNameLabel.text = model.name;
    self.briefLabel.text = model.memberPhone;
    NSURL *imageURL = [NSURL URLWithString:model.headUrl];
    [self.headImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"UserImage"]];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];

    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius  = CGRectGetHeight(self.headImageView.bounds)/2;

    [self.headImageView addGestureRecognizer:tapGR];

    self.companyNameLabel.userInteractionEnabled = YES;
    [self.companyNameLabel addGestureRecognizer:tapGR2];
        self.briefLabel.userInteractionEnabled = YES;
        [self.briefLabel addGestureRecognizer:tapGR3];

//        NSLog(@"%@",self.description);
//        NSLog(@"%@",self.subviews);
//        NSLog(@"%@",self.contentView.subviews);

}

- (void)tapClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiDetailShopInfo" object:nil];
}

- (IBAction)backButtonClick:(id)sender {
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiDetailBackHome" object:nil];
}
@end
