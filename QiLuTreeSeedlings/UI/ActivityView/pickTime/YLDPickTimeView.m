//
//  YLDPickTimeView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDPickTimeView.h"
#import "UIDefines.h"
@implementation YLDPickTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self createAddressToolBar:CGRectMake(0, frame.size.height-216-44,
                                              frame.size.width, 44)];
        
        UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,frame.size.height-216,frame.size.width,216)];
        self.pickerView=datePicker;
            datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *mindata=[NSDate new];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        self.selectDate=mindata;
        [self addSubview:datePicker];
        [ datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
        UITapGestureRecognizer *tapGestureR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerCancel:)];
        [self addGestureRecognizer:tapGestureR];
        
    }
    return self;
}
- (void)pickerDone:(id)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeStr=[formatter stringFromDate:self.selectDate];
    
    if ([self.delegate respondsToSelector:@selector(timeDate:andTimeStr:)]) {
        [self.delegate timeDate:self.selectDate andTimeStr:timeStr];
    }
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    // APPDELEGATE.showPickerV=nil;
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    self.selectDate=_date;
    /*添加你自己响应代码*/
}
- (void)pickerCancel:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    //  APPDELEGATE.showPickerV=nil;
}
- (void)createAddressToolBar:(CGRect)rect
{
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:rect];
    pickerDateToolbar.barStyle =  UIBarStyleDefault;
    pickerDateToolbar.translucent = YES;
    [pickerDateToolbar sizeToFit];
    [pickerDateToolbar setBackgroundColor:NavColor];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerCancel:)];
    [barItems addObject:cancelButton];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成   " style:UIBarButtonItemStyleDone target:self action:@selector(pickerDone:)];
    [barItems addObject:doneButton];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    [self addSubview:pickerDateToolbar];
}

- (void)showInView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
-(void)dismiss
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
