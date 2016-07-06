//
//  ZIKStationShowHonorView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowHonorView.h"
#import "UIImageView+AFNetworking.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface ZIKStationShowHonorView()

@property (weak, nonatomic) IBOutlet UIImageView *honorImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *honorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *honorTimeLabel;
@end

@implementation ZIKStationShowHonorView

+(ZIKStationShowHonorView *)instanceShowHonorView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKStationShowHonorView" owner:nil options:nil];
    ZIKStationShowHonorView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShowViewAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)removeShowViewAction {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, SCREEN_SIZE.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadData:(id <ZIKCertificateAdapterProtocol>)data {
    self.name             = [data name];
    self.time             = [data time];
    self.imageString      = [data imageString];
    self.issuingAuthority = [data issuingAuthority];
    self.level            = [data level];
    self.uid              = [data uid];
}

#pragma mark - 重写setter,getter方法
@synthesize name             = _name;
@synthesize time             = _time;
@synthesize imageString      = _imageString;
@synthesize issuingAuthority = _issuingAuthority;
@synthesize level            = _level;
@synthesize uid              = _uid;

-(void)setName:(NSString *)name {
    _name = name;
    _honorNameLabel.text = [NSString stringWithFormat:@"荣誉名称:%@",name];
}

-(NSString *)name {
    return _name;
}

-(void)setTime:(NSString *)time {
    _time = time;
    _honorTimeLabel.text = [NSString stringWithFormat:@"获奖时间:%@",time];
}

-(NSString *)time {
    return _time;
}

-(void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    NSURL *honorUrl = [NSURL URLWithString:imageString];
    [_honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
}

-(NSString *)imageString {
    return _imageString;
}

-(void)setIssuingAuthority:(NSString *)issuingAuthority {
    _issuingAuthority = issuingAuthority;
}

-(NSString *)issuingAuthority {
    return _issuingAuthority;
}

-(void)setLevel:(NSString *)level {
    _level = level;
}

-(NSString *)level {
    return _level;
}

-(void)setUid:(NSString *)uid {
    _uid = uid;
}

- (NSString *)uid {
    return _uid;
}

@end
