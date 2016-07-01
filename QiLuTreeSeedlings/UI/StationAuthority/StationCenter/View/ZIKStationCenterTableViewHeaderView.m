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

- (void)configWithModel:(MasterInfoModel *)model {
    NSURL *imageURL = [NSURL URLWithString:model.workstationPic];
    [self.headImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.nameLabel.text = model.chargelPerson;
    self.briefLabel.text = model.brief;

//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:@selector(tapClick) action:nil];
//
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:tapGR];

}


- (void)tapClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKChangeMasterInfo" object:nil];
}

- (IBAction)backBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];
}


@end
