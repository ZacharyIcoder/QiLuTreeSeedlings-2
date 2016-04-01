//
//  AppDelegate.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "GeTuiSdk.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"

#import "KeyboardManager.h"

#define kGtAppId           @"dxb5cYhXBW6yYLPsAfvtGA"
#define kGtAppKey          @"m2iC5d15as6Vub2OGIaxP6"
#define kGtAppSecret       @"9IHKXKIl7G7ozrvkOMQvx7"
@interface AppDelegate ()<GeTuiSdkDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BaseTabBarController *mainController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = mainController;
    [self.window makeKeyAndVisible];
    [self initData];

    self.userModel = [[UserInfoModel alloc]init];
    //自动登录
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[userDefaults objectForKey:kACCESS_TOKEN];
    NSString *uid=[userDefaults objectForKey:kACCESS_ID];
   // NSLog(@"%@---%@",token,uid);
    if (token&&uid) {
        self.userModel.access_token = token;
        self.userModel.access_id = uid;
        ShowActionV();
        [self reloadUserInfoSuccess:^(id responseObject) {
          
        } failure:^(NSError *error) {
           
        }];
        
    }
    //获取企业信息
    [self reloadCompanyInfo];
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    return YES;
}
-(void)reloadCompanyInfo
{
   
    [HTTPCLIENT getCompanyInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if (![[dic objectForKey:@"ishave"] isEqualToString:@"nocompany"]) {
                self.companyModel=[BusinessMesageModel creatBusinessMessageModelByDic:dic];
            }
            else{
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (BOOL)isNeedLogin
{
    return (self.userModel.name) ? YES : NO;
}
-(BOOL)isNeedCompany
{
    return (self.companyModel.uid) ? YES : NO;
}
- (void)requestBuyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"1" success:^(id responseObject) {
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublishBuy = NO;
            //NSLog(@"不可发布");
        }
        else {
            //NSLog(@"可发布");
            self.isCanPublishBuy = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)reloadUserInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    [HTTPCLIENT getUserInfoByToken:self.userModel.access_token byAccessId:self.userModel.access_id Success:^(id responseObject) {
        RemoveActionV();
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            //NSLog(@"%@",responseObject);
            
            if ([[responseObject objectForKey:@"error_code"] integerValue]==401) {
                [self logoutAction];
            }
            //NSLog(@"---%@",[responseObject objectForKey:@"msg"]);
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
            [self.userModel reloadInfoByDic:[responseObject objectForKey:@"result"]];
            success(responseObject);
            // NSLog(@"用户信息 %@",responseObject);
        }
       
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(void)logoutAction
{
    [ToastView showTopToast:@"您已退出登录"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kACCESS_ID];
    [userDefaults removeObjectForKey:kACCESS_TOKEN];
    [userDefaults synchronize];
    self.userModel=[[UserInfoModel alloc]init];
    BaseTabBarController *baseB=(BaseTabBarController *)self.window.rootViewController;
    baseB.homePageBtn.selected=YES;
    baseB.userInfoBtn.selected=NO;
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
       // NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}


#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 
 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [GeTuiSdk registerDeviceToken:myToken];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:myToken forKey:kdeviceToken];
    [userDefaults synchronize];
   // NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [GeTuiSdk registerDeviceToken:@""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"用户未授权" forKey:@"deviceToken"];
    [userDefaults synchronize];
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
   // NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    //NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    //NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    //NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
  //  NSString *msg = [NSString stringWithFormat:@" payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@", payloadId, taskId, aMsgId, payloadMsg, offLine ? @"<离线消息>" : @""];
  //  NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

- (void)initData
{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *gpsPath = [documentsDirectory stringByAppendingString: @"/config.xml"];
    //    [[NSFileManager defaultManager] createFileAtPath: gpsPath contents:nil attributes:nil];
    BOOL copySucceeded = NO;
    
    NSString *fileName = @"areadb";
    
    // Get our document path.
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    // Get the full path to our file.
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSLog(@"%@",filePath);
    // Get a file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Does the database already exist? (If not, copy it from our bundle)
    if(![fileManager fileExistsAtPath: filePath])
    {
        //CLog(@"copyFromBundle - checking for presence of \"%@\"...", fileName);
        // Get the bundle location
        NSString *bundleDBPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sqlite"];
        
        // Copy the DB to our document directory.
        copySucceeded = [fileManager copyItemAtPath:bundleDBPath
                                             toPath:filePath
                                              error:nil];
        
        if(!copySucceeded) {
            NSLog(@"copyFromBundle - Unable to copy \"%@\" to document directory.", fileName);
        }
        else {
            NSLog(@"copyFromBundle - Succesfully copied \"%@\" to document directory.", fileName);
        }
    }
    else
    {
        
    }
    
//    BaseDao *dao = [[BaseDao alloc] init];
//    [dao openDataBase];
//    [dao executeUpdate:sql];
//    [dao closeDataBase];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-5953523812-163.com.QiLuTreeSeedlings" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QiLuTreeSeedlings" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QiLuTreeSeedlings.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
