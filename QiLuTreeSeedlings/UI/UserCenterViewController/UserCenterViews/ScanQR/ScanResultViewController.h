//
//  BusinessesViewController.h
//  WiFiManger
//
//  Created by apple on 14-5-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSString *busnessName;
@property (nonatomic,retain) NSString *busnessImg;
@property (nonatomic,copy  ) NSString *jianjie;
@property (nonatomic,retain) NSString *resquestType;
@property (nonatomic,assign) int      urlint;
@end
