//
//  PickerLocation.m
//  baba88
//
//  Created by JCAI on 15/7/28.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "PickerLocation.h"
#import "GetCityDao.h"
@implementation Town

@synthesize TownID = _TownID;
@synthesize TownName = _TownName;


- (void)dealloc
{
    self.TownName = nil;
    self.TownName = nil;
    
    
}

- (Town *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.TownID = [dic objectForKey:@"id"];
            self.TownName = [dic objectForKey:@"name"];
            self.code=[dic objectForKey:@"code"];
            self.parent_code=[dic objectForKey:@"parent_code"];
            self.level=[dic objectForKey:@"level"];
        }
    }
    
    return self;
}

@end
@implementation City

@synthesize cityID = _cityID;
@synthesize cityName = _cityName;


- (void)dealloc
{
    self.cityID = nil;
    self.cityName = nil;
    
     
}

- (City *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.cityID = [dic objectForKey:@"id"];
            self.cityName = [dic objectForKey:@"name"];
            self.code=[dic objectForKey:@"code"];
            self.parent_code=[dic objectForKey:@"parent_code"];
            self.level=[dic objectForKey:@"level"];
            
            NSMutableArray *towns = [[NSMutableArray alloc] init];
            self.towns = towns;
            
        }
    }
    
    return self;
}

@end


@implementation Province

@synthesize provinceID = _provinceID;
@synthesize provinceName = _provinceName;
@synthesize citys = _citys;
@synthesize selectedCity = _selectedCity;

- (void)dealloc
{
    self.provinceID = nil;
    self.provinceName = nil;
    self.citys = nil;
    self.selectedCity = nil;
    
     
}

- (Province *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.provinceID = [dic objectForKey:@"id"];
            self.provinceName = [dic objectForKey:@"name"];
            self.code=[dic objectForKey:@"code"];
            self.parent_code=[dic objectForKey:@"parent_code"];
            self.level=[dic objectForKey:@"level"];
            NSMutableArray *citys = [[NSMutableArray alloc] init];
            self.citys = citys;
            }
    }
    
    return self;
}

@end



@interface PickerLocation () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,  strong) UIPickerView *pickerView;
@property (nonatomic,  strong) NSMutableArray *datasArray;
@property (nonatomic,  strong) Province *selectProvince;
@property (nonatomic,  strong) City *selectCity;
@end


@implementation PickerLocation

@synthesize locationDelegate = _locationDelegate;
@synthesize pickerView = _pickerView;
@synthesize datasArray = _datasArray;
@synthesize selectProvince = _selectProvince;



- (void)dealloc
{
    self.locationDelegate = nil;
    self.pickerView = nil;
    self.datasArray = nil;
    self.selectProvince = nil;
    
     
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        
        [self initLocationInfos];
        
        [self createAddressToolBar:CGRectMake(0, frame.size.height-216-44,
                                              frame.size.width, 44)];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:pickerView];
        self.pickerView = pickerView;

        self.pickerView.frame = CGRectMake(0, frame.size.height-216,
                                           frame.size.width,  216);
        
        
    }
    return self;
}

- (void)createAddressToolBar:(CGRect)rect
{
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:rect];
    pickerDateToolbar.barStyle =  UIBarStyleBlack;
    pickerDateToolbar.translucent = YES;
    [pickerDateToolbar sizeToFit];
    
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
    self.selectProvince = [self.datasArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.selectProvince.selectedCity = [self.selectProvince.citys objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    self.selectProvince.selectedCity.selectedTowns=[self.selectProvince.selectedCity.towns objectAtIndex:[self.pickerView selectedRowInComponent:2]];
    if ([self.locationDelegate respondsToSelector:@selector(selectedLocationInfo:)]) {
        [self.locationDelegate selectedLocationInfo:self.selectProvince];
    }
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
   
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
    }

#pragma mark -
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

#pragma mark - Picker Data and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        if (self.datasArray) {
            return [self.datasArray count];
        }
        else {
            return 0;
        }
    }
    if(component==1){
        if (self.selectProvince.citys) {
            return [self.selectProvince.citys count];
        }
        else {
            return 0;
        }
    }
    if (component==2) {
        if (self.selectCity.towns) {
            return [self.selectCity.towns count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componet
{
    if (componet==0) {
        if ([self.datasArray count]) {
            Province *province = [self.datasArray objectAtIndex:row];
            return province.provinceName;
        }
        else {
            return nil;
        }
    }
    if(componet==1) {
        if ([self.selectProvince.citys count]) {
            City *city = [self.selectProvince.citys objectAtIndex:row];
            return city.cityName;
        }
        else {
            return nil;
        }
    }
    if (componet==2) {
        if ([self.selectCity.towns count]) {
            Town *town=[self.selectCity.towns objectAtIndex:row];
            return town.TownName;
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        if ([self.datasArray count] > row) {
            self.selectProvince = [self.datasArray objectAtIndex:row];
            self.selectCity=nil;
            GetCityDao *dao = [[GetCityDao alloc] init];
            [dao openDataBase];
            if (self.selectProvince.citys.count==0) {
                GetCityDao *dao = [[GetCityDao alloc] init];
                [dao openDataBase];
                NSArray *allCity = [dao getCityByLeve:@"2" andParent_code:self.selectProvince.code];
                [dao closeDataBase];
                City *city = [[City alloc]init];
                city.cityName=@"不限";
                [self.selectProvince.citys addObject:city];
                for (NSDictionary *tempDic in allCity) {
                    City *city = [[City alloc] initWithDic:tempDic];
                    [self.selectProvince.citys addObject:city];
                }

            }
          

            [self.pickerView selectRow:0 inComponent:1 animated:NO];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:2 animated:NO];
            [self.pickerView reloadComponent:2];

        }
    }
    if (component==1) {
        if ([self.selectProvince.citys count] > row) {
            self.selectCity = [self.selectProvince.citys objectAtIndex:row];
            if (self.selectCity.towns.count==0) {
                GetCityDao *dao = [[GetCityDao alloc] init];
                [dao openDataBase];
                NSArray *allTown = [dao getCityByLeve:@"3" andParent_code:self.selectCity.code];
                [dao closeDataBase];
                Town *town = [[Town alloc]init];
                town.TownName=@"不限";
                [self.selectCity.towns addObject:town];
                for (NSDictionary *tempDic in allTown) {
                    Town *town = [[Town alloc] initWithDic:tempDic];
                    [self.selectCity.towns addObject:town];
                }

            }
            [self.pickerView selectRow:0 inComponent:2 animated:NO];
            [self.pickerView reloadComponent:2];
        }
    }
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

- (void)initLocationInfos
{
    NSMutableArray *datasArray = [[NSMutableArray alloc] init];
    self.datasArray = datasArray;
    GetCityDao *dao = [[GetCityDao alloc] init];
    [dao openDataBase];
    NSArray *tempArray = [dao getCityByLeve:@"1"];
    //[dao executeUpdate:sql];
    [dao closeDataBase];
    Province *provice = [[Province alloc] init];
    provice.provinceName=@"不限";
    [self.datasArray addObject:provice];
    for (NSDictionary *tempDic in tempArray) {
        Province *provice = [[Province alloc] initWithDic:tempDic];
        [self.datasArray addObject:provice];
    }
    
    if ([self.datasArray count]) {
        self.selectProvince = [self.datasArray objectAtIndex:0];
    }
}


- (void)setLocation:(NSString *)province :(NSString *)city
{
    for (NSInteger i=0; i < [self.datasArray count] ; i++) {
        Province *selectProvince = [self.datasArray objectAtIndex:i];
        if ([selectProvince.provinceID isEqualToString:province]) {
            self.selectProvince = selectProvince;
            [self.pickerView selectRow:i inComponent:0 animated:NO];
            
            NSArray *citys = self.selectProvince.citys;
            for (NSInteger i=0; i < [citys count] ; i++) {
                City *selectCity = [citys objectAtIndex:i];
                if ([selectCity.cityID isEqualToString:city]) {
                    self.selectProvince.selectedCity = selectCity;
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    break ;
                }
            }
            break ;
        }
    }

    
    if ([self.locationDelegate respondsToSelector:@selector(selectedLocationInfo:)]) {
        [self.locationDelegate selectedLocationInfo:self.selectProvince];
    }
}
-(void)dismiss
{
    [self removeFromSuperview];
}

@end
