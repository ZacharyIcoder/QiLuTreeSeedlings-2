//
//  PickerShowView.m
//  baba88
//
//  Created by JCAI on 15/7/22.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "PickerShowView.h"
#import "UIDefines.h"
@interface PickerShowView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,  strong) UIPickerView *pickerView;
@property (nonatomic,  strong) NSArray *datasArray;


@end


@implementation PickerShowView

@synthesize pickerView = _pickerView;
@synthesize datasArray = _datasArray;

- (void)dealloc
{
    self.pickerView = nil;
    self.datasArray = nil;
    
     
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self createAddressToolBar:CGRectMake(0, frame.size.height-216-44,
                                              frame.size.width, 44)];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:pickerView];
        self.pickerView = pickerView;

        self.pickerView.frame = CGRectMake(0,
                                           frame.size.height-216,
                                           frame.size.width,
                                           216);
        UITapGestureRecognizer *tapGestureR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerCancel:)];
        [self addGestureRecognizer:tapGestureR];
        
    }
    return self;
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

- (void)pickerDone:(id)sender
{
    NSString *selected = [self.datasArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSInteger selectNum=[self.pickerView selectedRowInComponent:0];
    if ([self.delegate respondsToSelector:@selector(selectNum:)]) {
        [self.delegate selectInfo:selected];
        [self.delegate selectNum:selectNum];
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

#pragma mark - Picker Data and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        if (self.datasArray) {
            return [self.datasArray count];
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componet
{
    if (componet==0) {
        if ([self.datasArray count]) {
            return [self.datasArray objectAtIndex:row];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        
    }
}

#pragma mark - 
- (void)resetPickerData:(NSArray *)datasArray
{
    self.datasArray = datasArray;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
   
}
- (void)resetPickerData:(NSArray *)datasArray andRow:(NSInteger)row
{
    self.datasArray = datasArray;
    [self.pickerView reloadAllComponents];
    if (!row) {
        row=0;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGRect tempFrame = self.frame;
    tempFrame.size.height -= 260;
    if (CGRectContainsPoint(tempFrame, location)) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [self setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

@end
