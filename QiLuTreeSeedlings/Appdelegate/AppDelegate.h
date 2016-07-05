//
//  AppDelegate.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserInfoModel.h"
#import "BusinessMesageModel.h"
#import "YLDGCGSModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, strong) BusinessMesageModel *companyModel;
@property (nonatomic, strong) YLDGCGSModel *GCGSModel;
@property (nonatomic)BOOL isCanPublishBuy;
/**
 *  是否来自单条购买界面（用来判断单条购买界面余额不足，进行充值）
 */
@property (nonatomic, assign) BOOL isFromSingleVoucherCenter;
-(BOOL)isNeedLogin;
-(BOOL)isNeedCompany;
-(void)reloadUserInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
-(void)logoutAction;
-(void)reloadCompanyInfo;
- (void)saveContext;
- (void)requestBuyRestrict;
- (NSURL *)applicationDocumentsDirectory;
-(void)getGchenggongsiInfo;
@end

