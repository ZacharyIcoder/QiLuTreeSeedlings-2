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
//友盟
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMMobClick/MobClick.h"
//微信
#import "WXApi.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import <AudioToolbox/AudioToolbox.h>
//引导页
#import "EAIntroView.h"
#define kGtAppId           @"dxb5cYhXBW6yYLPsAfvtGA"
#define kGtAppKey          @"m2iC5d15as6Vub2OGIaxP6"
#define kGtAppSecret       @"9IHKXKIl7G7ozrvkOMQvx7"
@interface AppDelegate ()<GeTuiSdkDelegate,WXApiDelegate,EAIntroDelegate>
@property (nonatomic,strong)EAIntroView *intro;
@end

@implementation AppDelegate
@synthesize intro;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BaseTabBarController *mainController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = mainController;
    [self.window makeKeyAndVisible];
    [self initData];
    [HTTPCLIENT getVersionSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
             NSInteger version=[[[responseObject objectForKey:@"result"] objectForKey:@"version"] integerValue];
            if (version>2) {
                [ToastView showTopToast:[[responseObject objectForKey:@"result"] objectForKey:@"updateContent"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    /*******************友盟分享*******************/
    //[UMSocialData setAppKey:@"569c3c37e0f55a8e3b001658"];
    //[UMSocialData defaultData].appKey = @"56fde8aae0f55a1cd300047c";
    [UMSocialData setAppKey:@"56fde8aae0f55a1cd300047c"];
    [UMSocialData openLog:YES];
    UMConfigInstance.appKey = @"56fde8aae0f55a1cd300047c";
    UMConfigInstance.token = @"56fde8aae0f55a1cd300047c";
    //UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];


    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx81b3cb415126671c" appSecret:@"1b7fcde03f9b195e9bc66db37e62ff07" url:@"http://www.qlmm.cn"];
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105469454" appKey:@"APPkey:LdUq6avQVQjxOZoD" url:@"http://www.qlmm.cn"];//16位0x41E4200E
    //向微信注册wx15fce880e520ad30
    [WXApi registerApp:@"wx81b3cb415126671c" withDescription:@"齐鲁苗木网"];
    /*******************友盟分享*******************/
   [self requestInitInfo];  

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
    [self requestBuyRestrict];
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
     application.applicationIconBadgeNumber = 0;
    return YES;
}
- (void)requestInitInfo {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"diyici"]) {
        // 注册APNS
        [self registerUserNotification];
        //[self judgeLogin];//判断是否需要登录
    }else{
      
        [self showIntroWithCrossDissolve];
    }
    
}

- (void)showIntroWithCrossDissolve {
    int height=(int)kHeight;
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title        = @"";
    page1.desc         = @"";
    page1.bgImage      = [UIImage imageNamed:[NSString stringWithFormat:@"1miaomu%d",height*2]];
    //page1.titleImage   = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title        = @"";
    page2.desc         = @"";
    page2.bgImage      = [UIImage imageNamed:[NSString stringWithFormat:@"2miaomu%d",height*2]];
    //page2.titleImage   = [UIImage imageNamed:@"supportcat"];
    
    
    intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page1,page2]];
    
    [intro setDelegate:self];
    [intro showInView:self.window animateDuration:0.0];
}

- (void)introDidFinish {
      [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"diyici"];
    [intro hideWithFadeOutDuration:0.0f];
    intro = nil;
    // 注册APNS
    [self registerUserNotification];
}
-(void)reloadCompanyInfo
{
    if ([self isNeedLogin]==NO) {
        return;
    }
   
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
    ShowActionV();
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"1" success:^(id responseObject) {
        RemoveActionV();
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
        RemoveActionV();
    }];
}
-(void)reloadUserInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    if (!self.userModel.access_token) {
        return;
    }
    [HTTPCLIENT getUserInfoByToken:self.userModel.access_token byAccessId:self.userModel.access_id Success:^(id responseObject) {
        RemoveActionV();
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            //NSLog(@"%@",responseObject);
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            if ([[responseObject objectForKey:@"error_code"] integerValue]==401) {
                [self logoutAction];
            }
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
    self.userModel=nil;
    self.companyModel=nil;
    self.isCanPublishBuy=NO;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:nil];
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
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [GeTuiSdk registerDeviceToken:@""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"用户未授权" forKey:@"deviceToken"];
    [userDefaults synchronize];
    //NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 标签
     application.applicationIconBadgeNumber = 0;
    if ([application applicationState]==UIApplicationStateActive) {
       
        SystemSoundID sound=1000;
        AudioServicesPlaySystemSound(sound);
        sound=kSystemSoundID_Vibrate;
        AudioServicesPlaySystemSound(sound);
    }
    if ([application applicationState]==UIApplicationStateInactive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:nil];
        
    }
    
    if ([application applicationState]==UIApplicationStateBackground) {
        
    }
   // NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    if ([application applicationState]==UIApplicationStateActive) {
        SystemSoundID sound=1000;
        AudioServicesPlaySystemSound(sound);
        sound=kSystemSoundID_Vibrate;
        AudioServicesPlaySystemSound(sound);
    }
    if ([application applicationState]==UIApplicationStateInactive) {
        NSString *tuisongType=[[userInfo objectForKey:@"aps"] objectForKey:@"category"];
        if ([tuisongType isEqualToString:@"push_buy"]) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"1"];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"0"];
        }
    }
    
    if ([application applicationState]==UIApplicationStateBackground) {
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
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
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
      //  NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    //NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
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
           // NSLog(@"copyFromBundle - Unable to copy \"%@\" to document directory.", fileName);
        }
        else {
           // NSLog(@"copyFromBundle - Succesfully copied \"%@\" to document directory.", fileName);
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
    //NSLog(@"- (void)applicationDidBecomeActive:(UIApplication *)application {");
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
       // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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


#pragma mark - 微信支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL appJump;

    if ([url.host isEqualToString:@"response_from_qq"] || [url.host isEqualToString:@"platformId=wechat"]) {

        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }

    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        appJump = YES;
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {

             NSString *aliRetValue = nil;

             if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
             {
                 aliRetValue = @"付款成功";
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil userInfo:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];

             }else
             {
                 aliRetValue = @"付款失败";
             }

             UIAlertView *aliPayAlert = [[UIAlertView alloc]initWithTitle:@"支付" message:aliRetValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             aliPayAlert.delegate = self;
             //aliPayAlert.tag = PAY_ALERT_TAG;
             [aliPayAlert show];


         }];
    }else{   //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK

        if ([url.host isEqualToString:@"pay"]) {

            appJump = [WXApi handleOpenURL:url delegate:self];

        }else
        {
            appJump = [UMSocialSnsService handleOpenURL:url];

        }
    }
    return  appJump;
}

#pragma mark -------WXPAY------------------------

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;

        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;

        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}



-(void) onResp:(BaseResp*)resp
{

    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;

    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){

        //支付返回结果，实际支付结果需要去微信服务器端查询

        strTitle           = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];//SinglePaySuccessNotification
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                break;

            default:

                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                break;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //alert.tag          = PAY_ALERT_TAG;
        [alert show];
    }
    
    
}


@end
