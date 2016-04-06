//
//  ZIKSideView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSideView.h"
#import "UIDefines.h"
#import "ZIKBaseViewController.h"
@interface ZIKSideView ()
@property (nonatomic, strong) NSArray *selectArray;
@end
@implementation ZIKSideView

-(void)didSelector:(NSString *)selectId title:(NSString *)selectTitle {
    self.pleaseSelectLabel.text = selectTitle;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.statle
        self.backgroundColor = kRGB(238, 238, 238, 1);
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        backView.backgroundColor = kRGB(0, 0, 0, 0.5);
        [self addSubview:backView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSideViewAction)];
        [backView addGestureRecognizer:tapGesture];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(Width/4, 0, Width*3/4, Height)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        UIView *selectTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 64)];
        selectTitleView.backgroundColor = kRGB(210, 210, 210, 1);

        UIButton *backButton = [[UIButton alloc] init];
        backButton.frame = CGRectMake(15, 7+20, 30, 30);
        [backButton setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
        [selectTitleView addSubview:backButton];
        [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2-40, 10+20, 80, 24)];
        titleLabel.text = @"选择苗木";
        //titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [selectTitleView addSubview:titleLabel];
        [contentView addSubview:selectTitleView];
        
        UIView *pleaseSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectTitleView.frame), selectTitleView.frame.size.width, 44)];
        self.pleaseSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, contentView.frame.size.width-10, 24)];
        _pleaseSelectLabel.textAlignment = NSTextAlignmentLeft;
        _pleaseSelectLabel.textColor = [UIColor darkGrayColor];
        _pleaseSelectLabel.font = [UIFont systemFontOfSize:17.0f];
        //_pleaseSelectLabel.text = @"请选择苗木";
        
        [pleaseSelectView addSubview:_pleaseSelectLabel];
        [contentView addSubview:pleaseSelectView];
        
        self.selectView = [[ZIKSelectView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pleaseSelectView.frame), pleaseSelectView.frame.size.width, contentView.frame.size.height-CGRectGetMaxY(pleaseSelectView.frame)) dataArray:self.dataArray];
        self.selectView.delegate = self;
        [contentView addSubview:self.selectView];
        

    }
    return self;
}

- (void)backBtnClick {
    if ([self.pleaseSelectLabel.text isEqualToString:@"请选择苗木"]) {
        [self removeSideViewAction];
    }
    else {
        _selectView.dataArray = self.selectArray;
        self.pleaseSelectLabel.text = @"请选择苗木";
    }
}

-(void)setDataArray:(NSArray *)dataArray {
    _selectView.dataArray = dataArray;
    _selectArray = dataArray;
}

#pragma mark - 隐藏视图
- (void)removeSideViewAction
{
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(Width, 0, Width, Height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
