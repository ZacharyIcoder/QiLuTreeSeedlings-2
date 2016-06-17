//
//  ZIKSearchBarView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKSearchBarView.h"
@interface ZIKSearchBarView ()
@property(nonatomic, weak) UIButton     *searIconBtn;
@property(nonatomic, weak) UIImageView  *backImageView;
@property(nonatomic, weak) UIButton     *leftBtn;
@end
@implementation ZIKSearchBarView
//-(instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;

        UIImageView *backImageView = [[UIImageView alloc] init];
        [self addSubview:backImageView];
        self.backImageView = backImageView;


        UITextField *textField = [[UITextField alloc] init];
        textField.returnKeyType = UIReturnKeySearch;
        textField.font = [UIFont systemFontOfSize:14];
        textField.tintColor = [UIColor darkGrayColor];
        [self addSubview:textField];
        self.textField = textField;


        UIButton *searchIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:searchIcon];
        [searchIcon addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [searchIcon setBackgroundImage:[UIImage imageNamed:@"searchBtnAction"] forState:UIControlStateNormal];
        self.searIconBtn = searchIcon;


        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:leftBtn];
        self.leftBtn = leftBtn;
    }

    return self;
}


- (void)layoutSubviews
{
    CGRect originRect = self.frame;
    CGFloat iconH = originRect.size.height/2.5;

    if (self.leftIcon) {
        self.leftBtn.frame = CGRectMake(10, 10, 24, 24);
        self.textField.frame  = CGRectMake(54, 5, originRect.size.width-54-iconH, originRect.size.height-10);
        self.backImageView.frame = CGRectMake(40, 8, originRect.size.width-50, originRect.size.height-16);
    }else
    {
        self.textField.frame  = CGRectMake(20, 5, originRect.size.width-20-iconH, originRect.size.height-10);
        self.backImageView.frame = CGRectMake(10, 8, originRect.size.width-20, originRect.size.height-16);
    }
    self.searIconBtn.frame = CGRectMake(originRect.size.width-iconH-20, (self.frame.size.height-iconH*2)/2, iconH*2, iconH*2);




}



- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}


- (void)setSearchIcon:(UIImage *)searchIcon
{
    _searchIcon = searchIcon;
    [self.searIconBtn setBackgroundImage:searchIcon forState:UIControlStateNormal];
}

- (void)setZhBackgroundImage:(UIImage *)zhBackgroundImage
{
    _zhBackgroundImage = zhBackgroundImage;
    self.backImageView.image = zhBackgroundImage;
}


- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    self.textField.delegate = delegate;
}

- (void)setSearchBlock:(SearchBlock)searchBlock
{
    _searchBlock = [searchBlock copy];

}


- (void)searchBtnClicked:(UIButton *)button
{
    if (self.searchBlock) {
        self.searchBlock(self.textField.text);
    }
    [self.textField resignFirstResponder];
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
    self.textField.userInteractionEnabled = NO;
    self.searIconBtn.userInteractionEnabled = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];

}


- (void)setLeftIcon:(UIImage *)leftIcon
{
    _leftIcon = leftIcon;

    [self.leftBtn setImage:leftIcon forState:UIControlStateNormal];
    CGRect originRect = self.frame;
    CGFloat iconH = originRect.size.height/2;

    self.leftBtn.frame = CGRectMake(20, 10, 24, 24);
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.frame  = CGRectMake(64, 10, originRect.size.width-64-iconH, originRect.size.height-20);

}


- (void)leftBtnClicked:(UIButton *)leftBtn
{
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }
}

@end
