//
//  NSString+NSString_MD5.h
//  Test
//
//  Created by zwh on 14-4-2.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString*) MD5Hash;

@end
