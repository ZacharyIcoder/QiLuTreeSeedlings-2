//
//  ZIKStationCenterTableViewHeaderView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterTableViewHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "MasterInfoModel.h"
@interface ZIKStationCenterTableViewHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;


@end

@implementation ZIKStationCenterTableViewHeaderView

- (IBAction)shareButtonClick {
   // NSLog(@"分享");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKUMShare" object:nil];
}

- (void)configWithModel:(MasterInfoModel *)model {
    NSURL *imageURL = [NSURL URLWithString:model.workstationPic];
    [self.headImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.nameLabel.text  = model.chargelPerson;
    self.briefLabel.text = model.phone;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    UITapGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];

    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius  = CGRectGetHeight(self.headImageView.bounds)/2;

    [self.headImageView addGestureRecognizer:tapGR];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tapGR2];
    self.briefLabel.userInteractionEnabled = YES;
    [self.briefLabel addGestureRecognizer:tapGR3];

}


- (void)tapClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKChangeMasterInfo" object:nil];
}

- (IBAction)backBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}


@end
