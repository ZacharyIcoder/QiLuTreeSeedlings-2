//
//  ZIKMiaoQiZhongXinHeaderFooterView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinHeaderFooterView.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKMiaoQiZhongXinModel.h"
#import "UIDefines.h"
@interface ZIKMiaoQiZhongXinHeaderFooterView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareTextButton;
@property (weak, nonatomic) IBOutlet UIButton *shareImageButton;
@end

@implementation ZIKMiaoQiZhongXinHeaderFooterView
- (IBAction)shareButtonClick:(id)sender {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiZhongXinUMShare" object:nil];
}

- (void)configWithModel:(ZIKMiaoQiZhongXinModel *)model {
    self.shareTextButton.hidden = YES;
    self.shareImageButton.hidden = YES;
    
    NSURL *imageURL = [NSURL URLWithString:APPDELEGATE.userModel.headUrl];
    [self.headImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.companyNameLabel.text  = model.companyName;
    self.nameLabel.text = model.name;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius  = CGRectGetHeight(self.headImageView.bounds)/2;

    [self.headImageView addGestureRecognizer:tapGR];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tapGR2];
//    self.briefLabel.userInteractionEnabled = YES;
//    [self.briefLabel addGestureRecognizer:tapGR3];

}


- (void)tapClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiChangeMasterInfo" object:nil];
}


- (IBAction)backButtonClick:(id)sender {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKMiaoQiBackHome" object:nil];
}
@end
