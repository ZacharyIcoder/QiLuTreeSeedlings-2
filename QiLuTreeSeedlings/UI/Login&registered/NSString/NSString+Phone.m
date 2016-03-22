//
//  NSString+Phone.m
//  baba88
//
//  Created by JCAI on 15/7/21.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "NSString+Phone.h"

@implementation NSString (Phone)

- (BOOL)checkPhoneNumInput
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1[0-9]{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:self];
}

@end
