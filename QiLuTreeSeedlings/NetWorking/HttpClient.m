//
//  HttpClient.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/25.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HttpClient.h"
#import "HttpDefines.h"
//#import "DataCache.h"
#import "UIDefines.h"

@implementation HttpClient
+ (instancetype)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:AFBaseURLString]];
         _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
         _sharedClient.requestSerializer.timeoutInterval = 20.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return _sharedClient;
}
#pragma mark -网络异常判断
+(void)HTTPERRORMESSAGE:(NSError *)errorz
{
    NSString *messageStr=[errorz.userInfo objectForKey:@"NSLocalizedDescription"];
    [ToastView showTopToast:messageStr];
}
#pragma mark -首页
- (void)getHomePageInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apiindex";
        NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                  @"10",@"keywordCount",
                                  @"10",@"recommendCount",
                                   @"10",@"supplyCount",
                                  APPDELEGATE.userModel.access_id,@"access_id",nil];
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -版本检测
-(void)getVersionSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"iosVersion";
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -修改个人信息
-(void)changeUserInfoWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      withName:(NSString *)name
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/updatename";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"] = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"] = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"] = kclient_id;
    parmers[@"client_secret"] = kclient_secret;
    parmers[@"device_id"] = str;
    parmers[@"name"] = name;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-修改密码
-(void)changeUserPwdWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithOldPassWord:(NSString *)oldPwd
               WithNewPassWord:(NSString *)newPwd
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];

    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/modifypassword";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"oldPassword"]      = oldPwd;
    parmers[@"plainPassword"]    = newPwd;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark-取消苗圃
-(void)cancelMiaoPuWithToken:(NSString *)token
                WithAccessID:(NSString *)accessID
                WithClientID:(NSString *)clientID
            WithClientSecret:(NSString *)clientSecret
                WithDeviceID:(NSString *)deviceID
                     WithIds:(NSString *)ids
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/nursery/delete";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              ids,@"ids",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-上传个人头像
-(void)upDataUserImageWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                     WithUserIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"fileUpload/uploadphotoios";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];

    NSData* imageData;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 0.0001);
    }
    if (imageData.length>=1024*1024) {
        CGSize newSize = {600,600};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"file"]             = myStringImageFile;
    parmers[@"fileName"]         = @"personHeadImage.png";
    //NSLog(@"%@",parameters);
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
-(NSData*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.

    return UIImagePNGRepresentation(newImage);
}

#pragma mark-上传图片
-(void)upDataIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apiupload";

    NSData *iconData=UIImageJPEGRepresentation(image, 0.1);
    [self POST:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"file" fileName:@"testImage" mimeType:@"image/png/file"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark-站长信息列表
-(void)getWrokStationListWithToken:(NSString *)token
                      WithAccessID:(NSString *)accessID
                      WithClientID:(NSString *)clientID
                  WithClientSecret:(NSString *)clientSecret
                      WithDeviceID:(NSString *)deviceID
                WithWorkstationUId:(NSString *)workstationUId
                      WithAreaCode:(NSString *)areaCode
                          WithPage:(NSString *)page
                      WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/wrokStationListoutme";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"workstationUId"]   = APPDELEGATE.userModel.workstationUId;
    parmers[@"areaCode"]         = areaCode;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark-求购信息收藏列表
-(void)collectBuyListWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      WithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/buy";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              page,@"page",
                              pageSize,@"pageSize",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-供应信息收藏列表
-(void)collectSellListWithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/supply";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              page,@"page",
                              pageSize,@"pageSize",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-供应信息列表
-(void)SellListWithWithPageSize:(NSString *)pageSize
                       WithPage:(NSString *)page
               Withgoldsupplier:(NSString *)goldsupplier
                 WithSerachTime:(NSString *)searchTime
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply";
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    parameters[@"page"]=page;
    parameters[@"pageSize"]=pageSize;
    parameters[@"searchTime"]=searchTime;
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购信息列表
-(void)BuyListWithWithPageSize:(NSString *)pageSize
                    WithStatus:(NSString *)status
               WithStartNumber:(NSString *)startNumber
                withSearchTime:(NSString *)searchTime
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              pageSize,@"pageSize",
                              status,@"status",
                              startNumber,@"startNumber",
                              nil];
    parameters[@"searchTime"]=searchTime;
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购检索
-(void)buySearchWithPage:(NSString *)page
            WithPageSize:(NSString *)pageSize
        Withgoldsupplier:(NSString *)goldsupplier
          WithproductUid:(NSString *)productUid
         WithproductName:(NSString *)productName
            WithProvince:(NSString *)province
                WithCity:(NSString *)city
              WithCounty:(NSString *)county
          WithsearchTime:(NSString *)searchTime
                 WithAry:(NSArray *)ary
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy/search";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"2" forKey:@"type"];
    [parameters setObject:page forKey:@"page"];
    [parameters setObject:pageSize forKey:@"pageSize"];
    if (productName) {
         [parameters setObject:productName forKey:@"productName"];
    }
    if (goldsupplier) {
        [parameters setObject:goldsupplier forKey:@"goldsupplier"];
    }
    if (productUid) {
        [parameters setObject:productUid forKey:@"productUid"];

    }
    if (province) {
        [parameters setObject:province forKey:@"province"];
    }
    if (city) {
       [parameters setObject:city forKey:@"city"];
    }
    if (county) {
        [parameters setObject:county forKey:@"county"];
    }
    parameters[@"searchTime"]=searchTime;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购详情
-(void)buyDetailWithUid:(NSString *)uid
           WithAccessID:(NSString *)access_id
               WithType:(NSString *)type
    WithmemberCustomUid:(NSString *)memberCustomUid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy/detail";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                            uid,@"uid",
                            access_id,@"access_id",
                            type,@"type",
                            memberCustomUid,@"memberCustomUid",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-我的求购编辑
-(void)myBuyEditingWithUid:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
    NSString *postURL = @"api/apibuy/updateios";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              uid,@"uid",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    

    // 4.创建参数字符串对象
    //NSString *parmStr = @"access_id=0F14ED77-78E2-4441-9F1A-8FE080C9A6C1&access_token=1db43fde59854beb38c0423145d2e2bd&client_id=00C6D374-930C-472B-9B98-D759ACD2F98D&client_secret=49C851D0-C075-4630-99D6-1CF609697626&device_id=019672763a1f29acb97bbb8468d329b5b44a82642b04cafaa37a53a99044b82d&uid=3BD31D90-9F91-4492-BB97-C6052182F1AB";

}
#pragma mark-供应详情
-(void)sellDetailWithUid:(NSString *)uid
            WithAccessID:(NSString *)access_id
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply/detail";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              uid,@"uid",
                              access_id,@"access_id",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-热门搜索
-(void)hotkeywordWithkeywordCount:(NSString *)keyWordCount
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apihotkeyword";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"10",@"keywordCount",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-供应检索
-(void)sellSearchWithPage:(NSString*)page
             WithPageSize:(NSString *)pageSize
         Withgoldsupplier:(NSString *)goldsupplier
           WithProductUid:(NSString *)productUid
          WithProductName:(NSString *)productName
             WithProvince:(NSString *)province
                 WithCity:(NSString *)city
               WithCounty:(NSString *)county
           WithSearchTime:(NSString *)searchTime
                  WithAry:(NSArray *)ary
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply/search";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"2" forKey:@"type"];
    [parameters setObject:page forKey:@"page"];
    [parameters setObject:pageSize forKey:@"pageSize"];
    if (productName) {
        [parameters setObject:productName forKey:@"productName"];
    }
    if (goldsupplier) {
        [parameters setObject:goldsupplier forKey:@"goldsupplier"];
    }
    if (productUid) {
        [parameters setObject:productUid forKey:@"productUid"];
        
    }
    if (province) {
        [parameters setObject:province forKey:@"province"];
    }
    if (city) {
        [parameters setObject:city forKey:@"city"];
    }
    if (county) {
        [parameters setObject:county forKey:@"county"];
    }
    parameters[@"searchTime"]=searchTime;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@",responseObject);
        if([[responseObject objectForKey:@"success"] integerValue])
        {
          success(responseObject);
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            RemoveActionV();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-根据苗木名称获取规格属性
-(void)getMmAttributeWith:(NSString *)name
                 WithType:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupplybuy/getProductSpec";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                             name,@"name",
                             type,@"type",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        RemoveActionV();
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-登录
-(void)loginInWithPhone:(NSString *)phone
            andPassWord:(NSString *)passWord
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *device_id = [userDefaults objectForKey:@"deviceToken"];
    if (!device_id) {
        device_id=@"用户未授权";
    }
   // NSLog(@"%@",device_id);
    ShowActionV();
    NSString *postURL = @"authorize";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"password",@"grant_type",
                              phone,@"username",
                              passWord,@"password",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              device_id,@"device_id",
                              @"token",@"response_type",
                              nil];
   // NSLog(@"%@",parameters);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [self updataClient_id];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
-(void)updataClient_id
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *device_id = [userDefaults objectForKey:@"deviceToken"];
    if (!device_id) {
        return;
    }
    NSString *postURL = @"api/client";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              device_id,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              device_id,@"cid",
                              @"2",@"type",
                              nil];


    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];

}
#pragma mark-帐号注册
-(void)registeredUserWithPhone:(NSString *)phone
                  withPassWord:(NSString *)password
                withRepassWord:(NSString *)repassword
                      withCode:(NSString *)code
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/member/account/register";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              phone,@"phone",
                              password,@"password",
                              repassword,@"repassword",
                              code,@"code",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-获取短信验证码
-(void)getCodeShotMessageWtihPhone:(NSString *)phone
                           andType:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/member/account/getIdentifyingCode";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              phone,@"phone",
                              type,@"type",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-个人信息
-(void)getUserInfoByToken:(NSString *)token
               byAccessId:(NSString *)accessId
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
     NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/account/info";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessId,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -退出登录
-(void)logoutInfoByToken:(NSString *)token
              byAccessId:(NSString *)accessId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
    NSString *postURL = @"api/member/account/logout";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessId,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -供应信息收藏
-(void)collectSupplyWithSupplyNuresyid:(NSString *)nuresyid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/supply/save";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              nuresyid,@"supplynuresyid",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -求购信息收藏
-(void)collectBuyWithSupplyID:(NSString *)supply_id
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/buy/saveios";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              supply_id,@"supply_id",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -取消收藏
-(void)deletesenderCollectWithIds:(NSString *)ids
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/delete";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              ids,@"ids",
                              
                              nil];
    //NSLog(@"%@",ids);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -我的求购列表
-(void)myBuyInfoListWtihPage:(NSString *)page
                   WithState:(NSString *)state
              WithsearchTime:(NSString *)searchTime
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/buy/my";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              //ids,@"ids",
                              page,@"page",
                              @"15",@"pageSize",
                              state,@"state",
                              nil];
    parameters[@"searchTime"]=searchTime;
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -我的求购信息保存
-(void)fabuBuyMessageWithUid:(NSString *)uid
                   Withtitle:(NSString *)title
                    WithName:(NSString *)name
              WithProductUid:(NSString *)productUid
                   WithCount:(NSString *)count
                   WithPrice:(NSString *)price
           WithEffectiveTime:(NSString *)effectiveTime
                  WithRemark:(NSString *)remark
                WithusedArea:(NSString *)usedArea
                     WithAry:(NSArray  *)ary
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/apibuy/create";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              nil];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:parameter];
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
    }
    if (title) {
        [parameters setObject:title forKey:@"title"];
    }
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    if (productUid) {
        [parameters setObject:productUid forKey:@"productUid"];
    }
    
    if (count) {
        [parameters setObject:count forKey:@"count"];
    }
    if (price) {
        [parameters setObject:price forKey:@"price"];
    }
    if (effectiveTime) {
        [parameters setObject:effectiveTime forKey:@"effectiveTime"];
    }
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }
    if (usedArea) {
        [parameters setObject:usedArea forKey:@"usedArea"];
    }
 
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
#pragma mark -获取企业信息
-(void)getCompanyInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/company/info";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -保存企业信息
-(void)saveCompanyInfoWithUid:(NSString *)uid
              WithCompanyName:(NSString *)name
           WithCompanyAddress:(NSString *)companyAddress
      WithcompanyAreaProvince:(NSString *)companyAreaProvince
          WithcompanyAreaCity:(NSString *)companyAreaCity
        WithcompanyAreaCounty:(NSString *)companyAreaCounty
          WithcompanyAreaTown:(NSString *)companyAreaTown
              WithlegalPerson:(NSString *)legalPerson
                    Withphone:(NSString *)phone
                  Withzipcode:(NSString *)zipcode
                    Withbrief:(NSString *)brief
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
      str=@"USERLOCK";
   }
    NSString *postURL = @"api/company/save";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             nil];
    //NSLog(@"%@",parameter);
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:parameter];
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
    }
    if (name) {
        [parameters setObject:name forKey:@"companyName"];
    }
    if (companyAddress) {
        [parameters setObject:companyAddress forKey:@"companyAddress"];
    }
    if (companyAreaProvince) {
        [parameters setObject:companyAreaProvince forKey:@"companyAreaProvince"];
    }
    if (companyAreaCounty) {
        [parameters setObject:companyAreaCounty forKey:@"companyAreaCounty"];
    }else
    {
        [parameters setObject:@"" forKey:@"companyAreaCounty"];
    }
    
    if (companyAreaCity) {
        [parameters setObject:companyAreaCity forKey:@"companyAreaCity"];
    }else
    {
        [parameters setObject:@"" forKey:@"companyAreaCity"];
    }
    if (companyAreaTown) {
        [parameters setObject:companyAreaTown forKey:@"companyAreaTown"];
    }else
    {
        [parameters setObject:@"" forKey:@"companyAreaTown"];
    }
    if (legalPerson) {
        [parameters setObject:legalPerson forKey:@"legalPerson"];
    }
    
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (zipcode) {
        [parameters setObject:zipcode forKey:@"zipcode"];
    }
    if (brief) {
        [parameters setObject:brief forKey:@"brief"];
    }
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -苗圃列表信息
-(void)getNurseryListWithPage:(NSString *)page
                 WithPageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/list";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             page,@"page",
                             pageSize,@"pageSize",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -苗圃详情
-(void)nurseryDetialWithUid:(NSString *)uid
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/info";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             uid,@"nrseryId",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -添加/修改苗圃信息
-(void)saveNuresryWithUid:(NSString *)uid
          WithNurseryName:(NSString *)nurseryName
  WithnurseryAreaProvince:(NSString *)nurseryAreaProvince
      WithnurseryAreaCity:(NSString *)nurseryAreaCity
    WithnurseryAreaCounty:(NSString *)nurseryAreaCounty
      WithnurseryAreaTown:(NSString *)nurseryAreaTown
       WithnurseryAddress:(NSString *)nurseryAddress
        WithchargelPerson:(NSString *)chargelPerson
                WithPhone:(NSString *)phone
                Withbrief:(NSString *)brief
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/save";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             nil];
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
    }
    if (nurseryName) {
        [parameters setObject:nurseryName forKey:@"nurseryName"];
    }
    if (nurseryAreaProvince) {
        [parameters setObject:nurseryAreaProvince forKey:@"nurseryAreaProvince"];
    }
    if (nurseryAreaCity) {
        [parameters setObject:nurseryAreaCity forKey:@"nurseryAreaCity"];
    }else
    {
        [parameters setObject:@"" forKey:@"nurseryAreaCity"];
    }
    if (nurseryAreaCounty) {
        [parameters setObject:nurseryAreaCounty forKey:@"nurseryAreaCounty"];
    }else
    {
        [parameters setObject:@"" forKey:@"nurseryAreaCounty"];
    }
    if (nurseryAreaTown) {
        [parameters setObject:nurseryAreaTown forKey:@"nurseryAreaTown"];
    }
    else{
        [parameters setObject:@"" forKey:@"nurseryAreaTown"];
    }
    if (nurseryAddress) {
        [parameters setObject:nurseryAddress forKey:@"nurseryAddress"];
    }
    if (chargelPerson) {
        [parameters setObject:chargelPerson forKey:@"chargelPerson"];
    }
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (brief) {
        [parameters setObject:brief forKey:@"brief"];
    }
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 供求发布限制 -----------
-(void)getSupplyRestrictWithToken:(NSString *)token withId:(NSString *)accessID withClientId:(NSString *)clientID withClientSecret:(NSString *)clientSecret withDeviceId:(NSString *)deviceID withType:(NSString *)typeInt success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supplybuy/checknursery";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              typeInt,@"type",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 我的供应列表 -----------
- (void)getMysupplyListWithToken:(NSString *)token withAccessId:(NSString *)accessID withClientId:(NSString *)clientID withClientSecret:(NSString *)clientSecret withDeviewId:(NSString *)deviceId withState:(NSString *)state withPage:(NSString *)page withPageSize:(NSString *)pageSize success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supply/my";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                APPDELEGATE.userModel.access_token,@"access_token",
                                APPDELEGATE.userModel.access_id,@"access_id",
                                kclient_id,@"client_id",
                                kclient_secret,@"client_secret",
                                str,@"device_id",
                                state,@"state",
                                page,@"page",
                                pageSize,@"pageSize",
                                nil];
    ShowActionV()
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
         RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

-(void)upDataImageIOS:(NSString *)imageString
       workstationUid:(NSString *)workstationUid
           companyUid:(NSString *)companyUid
                 type:(NSString *)type
             saveTyep:(NSString *)saveType
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiuploadios";
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                imageString,@"file",
//                                @"gongyingtupian.png",@"fileName",
//                                nil];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"file"]             = imageString;
    parmers[@"fileName"]         = @"tupian.png";
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"companyUid"]       = companyUid;
    parmers[@"type"]             = type;
    parmers[@"saveType"]         = saveType;
    //NSLog(@"%@",parameters);
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}


#pragma mark-上传图片
-(void)upDataImage:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
{
    NSString *postURL = @"apiuploadios";
    
    NSData *iconData = UIImageJPEGRepresentation(image, 0.1);
    //    self.responseSerializer =  [AFHTTPResponseSerializer serializer];//3840
    //    self.requestSerializer  = [AFHTTPRequestSerializer serializer];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"file"] = @"imagefile";
    //    params[@"fileName"] = @"imagefileName.png";
    //[GTMBase64 stringByEncodingData:iconData];
    [self POST:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"file" fileName:@"kong" mimeType:@"image/png/file"];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:[self documentFolderPath]] name:@"testImage" error:nil];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@kong",[self documentFolderPath]]] name:@"testImage" error:nil];
        //[formData appendPartWithFileData:iconData name:@"imagefile" fileName:@"imagefileName" mimeType:@"image/png/file"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

- (void)getTypeInfoSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiproducttype";
//    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
//                              @"10",@"keywordCount",
//                              @"10",@"recommendCount",
//                              @"5",@"supplyCount", nil];
    ShowActionV();
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

- (void)getProductWithTypeUid:(NSString *)typeUid
                         type:(NSString *)type
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiproduct";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                  typeUid,@"typeUid",
                                     type,@"type",nil];
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息保存 -----------
- (void)saveSupplyInfoWithAccessToken:(NSString *)accesToken
                             accessId:(NSString *)accessId
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                             deviceId:(NSString *)deviceId
                                  uid:(NSString *)uid
                                title:(NSString *)title
                                 name:(NSString *)name
                           productUid:(NSString *)productUid
                                count:(NSString *)count
                                price:(NSString *)price
                        effectiveTime:(NSString *)time
                               remark:(NSString *)remark
                           nurseryUid:(NSString *)nurseryUid
                            imageUrls:(NSString *)imageUrls
                    imageCompressUrls:(NSString *)imageCompressUrls
          withSpecificationAttributes:(NSArray *)etcAttributes
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {

    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/apisupply/create";
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"uid"]               = uid;
    parmers[@"title"]             = title;
    parmers[@"name"]              = name;
    parmers[@"productUid"]        = productUid;
    parmers[@"count"]             = count;
    parmers[@"price"]             = price;
    parmers[@"effectiveTime"]     = time;
    parmers[@"remark"]            = remark;
    parmers[@"nurseryUid"]        = nurseryUid;
    parmers[@"imageUrls"]         = imageUrls;
    parmers[@"imageCompressUrls"] = imageCompressUrls;
    NSArray *array = etcAttributes[0];
//    for (int i=0; i < array.count; i++) {
//        NSDictionary *dic = array[i];
//        NSString *field =  dic[@"field"];
//        parmers[field]  = [dic objectForKey:@"anwser"];
//        //[parmers setObject:[dic objectForKey:@"anwser"] forKey:[dic objectForKey:@"field"]];
//    }
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        [parmers setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息详情 -----------
- (void)getMySupplyDetailInfoWithAccessToken:(NSString *)accesToken
                                    accessId:(NSString *)accessId
                                    clientId:(NSString *)clientId
                                clientSecret:(NSString *)clientSecret
                                    deviceId:(NSString *)deviceId
                                         uid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supply/my/detail";
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"uid"]               = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 收到的我的订制信息 -----------
- (void)getMyCustomizedListInfoWithPageNumber:(NSString *)pageNumber
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的定制信息列表 -----------
- (void)getCustomSetListInfo:(NSString *)pageNumber
                    pageSize:(NSString *)pageSize
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];


}

#pragma mark ---------- 消费记录 -----------
- (void)getConsumeRecordInfoWithPageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/consume/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

- (void)weixinPayOrder:(NSString *)price
          supplyBuyUid:(NSString *)supplyBuyUid
                  type:(NSString *)type
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    //NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    //NSString *str                = [userdefaults objectForKey:kdeviceToken];
//    NSString *postURL            = @"apimember/pay/wx/notify/";
    NSString *postURL            = @"apimember/pay/wx/order";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"total_fee"]        = price;
    parmers[@"memberUid"]        = APPDELEGATE.userModel.access_id;
    parmers[@"spbill_create_ip"] = kclient_id;
    parmers[@"supplyBuyUid"]     = supplyBuyUid;
    parmers[@"type"]             = type;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 银联获取tn交易号方法 -----------
- (void)getUnioPay:(NSString *)price
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"apimember/pay/unionpay/order";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"txnAmt"]        = price;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];


}
- (void)getUnioPayTnString:(NSString *)price
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"apimember/pay/unionpay/order";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"txnAmt"]        = price;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-个人积分
-(void)getMyIntegralListWithPageNumber:(NSString *)pageNumber
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = @"15";
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息修改 -----------
-(void)mySupplyUpdataWithUid:(NSString *)uid
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apisupply/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的订制设置保存 -----------
- (void)saveMyCustomizedInfo:(NSString *)uid
                  productUid:(NSString *)productUid
                usedProvince:(NSString *)usedProvince
                    usedCity:(NSString *)usedCity
 withSpecificationAttributes:(NSArray *)etcAttributes
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/member/push/customset/create";
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"uid"]               = uid;
    parmers[@"productUid"]        = productUid;
    parmers[@"usedProvince"]      = usedProvince;
    parmers[@"usedCity"]          = usedCity;
    NSArray *array = etcAttributes[0];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        [parmers setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}

#pragma mark ---------- 我的订制设置修改信息 -----------
- (void)getMyCustomsetEditingWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"customsetUid"]     = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的供应信息批量删除 -----------
- (void)deleteMySupplyInfo:(NSString *)uids
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apisupply/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购信息批量删除
- (void)deleteMyBuyInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的定制信息批量删除 -----------
- (void)deleteCustomSetInfo:(NSString *)uids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset/deleteBatch";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的苗圃信息批量删除
- (void)deleteMyNuseryInfo:(NSString *)uids
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/nursery/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]             = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 获得当前用户余额 -----------
- (void)getAmountInfo:(NSString *)nilString
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/getamount";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
     [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 是否首次充值 -----------
- (void)isFirstRecharge:(NSString *)nilString
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/consume/isfirstcz";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的收藏猜你喜欢供应列表
-(void)myCollectionYouLikeSupplyWithPage:(NSString *)pageNum
                            WithPageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/collect/supplylike";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = pageNum;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark 求购联系方式购买
-(void)payForBuyMessageWithBuyUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"apibuy/buy";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark 我的求购信息关闭
-(void)closeMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/close";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]              = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购信息打开
-(void)openMyBuyMessageWithUids:(NSString *)uids
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/open";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]              = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购退回原因
-(void)MyBuyMessageReturnReasonWihtUid:(NSString *)Uid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/reason";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = Uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 购买记录 -----------
- (void)purchaseHistoryWithPage:(NSString *)page
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/purchaseHistory";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = @"15";
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 购买记录删除 -----------
- (void)purchaseHistoryDeleteWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/purchaseHistory/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 手动刷新供应 -----------
- (void)sdsupplybuyrRefreshWithUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/sdsupplybuy/refresh";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 分享等单条非手动刷新供应 -----------
- (void)supplybuyrRefreshWithUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/supplybuy/refresh";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 消息列表 -----------
-(void)messageListWithPage:(NSString *)page
              WithPageSize:(NSString *)pageSize
                 WithReads:(NSString *)reads
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"reads"]            = reads;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 单条消息设置已读 -----------
-(void)myMessageReadingWithUid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord/read";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]             = uid;

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 批量消息删除 -----------
-(void)myMessageDeleteWithUid:(NSString *)uids
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]             = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 验证手机号是否存在 -----------
-(void)checkPhoneNum:(NSString *)phone
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/member/checkPhone";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 忘记密码，验证手机验证码是否正确 -----------
-(void)checkChongzhiPassWorldWihtPhone:(NSString *)phone
                              WithCode:(NSString *)code
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString *postURL            = @"api/member/checkVerificationCode";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    parmers[@"code"]             = code;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 设置新密码 -----------
-(void)setNewPassWordWithPhone:(NSString *)phone
                  WithPassWord:(NSString *)password
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    NSString *postURL            = @"api/member/resetPwd";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    parmers[@"password"]          = password;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 我的供应详情-分享供应 -----------
-(void)supplyShareWithUid:(NSString *)uid
               nurseryUid:(NSString *)nurseryUid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/supply/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"nurseryUid"]       = nurseryUid;

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 我的订制信息 -----------
-(void)customizationUnReadWithPageSize:(NSString *)pageSize
                            PageNumber:(NSString *)pageNumber
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 按产品ID查询订制信息 -----------
- (void)recordByProductWithProductUid:(NSString *)productUid
                             pageSize:(NSString *)pageSize
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/recordByProduct";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
//#warning pageNumber pageSize
    parmers[@"pageNumber"]       = pageSize;
    parmers[@"pageSize"]         = @"15";
    parmers[@"productUid"]       = productUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 批量删除订制信息（按条） -----------
- (void)deleterecordWithIds:(NSString *)ids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/deleterecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]       = ids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 批量删除订制信息（按树种） -----------
- (void)deleteprorecordWithIds:(NSString *)ids
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/deleteprorecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]              = ids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}



#pragma mark ---------- 求购分享 -----------
- (void)buyShareWithUid:(NSString *)uid
                  state:(NSString *)state
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/buy/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"state"]            = state;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 按树名获取苗木规格属性 -----------
-(void)huoqumiaomuGuiGeWithTreeName:(NSString *)name
                            andType:(NSString *)type andMain:(NSString *)main
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
  
    NSString *postURL            = @"apisupplybuy/getProductSpec";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"name"]     = name;
    parmers[@"type"]        = type;
    parmers[@"main"]        = main;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 根据关联规格ID获取下一级 -----------
-(void)huoquxiayijiguigeWtithrelation:(NSString *)relation
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"apinextspec";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"relation"]     = relation;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 客服系统 -----------
-(void)kefuXiTongWithPage:(NSString *)pageSize
           WithPageNumber:(NSString *)pageNum
               WithIsLoad:(NSString *)isLoad
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/kefu";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageSize"]     = pageSize;
    parmers[@"pageNumber"]     = pageNum;
     parmers[@"isLoad"]     = isLoad;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 积分兑换规则 -----------
- (void)integraRuleSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
           NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
           NSString *str                = [userdefaults objectForKey:kdeviceToken];
           NSString *postURL            = @"api/integral/exchange/rule";
           NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
           parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
           parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
           parmers[@"client_id"]        = kclient_id;
           parmers[@"client_secret"]    = kclient_secret;
           parmers[@"device_id"]        = str;
           ShowActionV();
           [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
               
               
           
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               success(responseObject);
               RemoveActionV();
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error);
               RemoveActionV();
               [HttpClient HTTPERRORMESSAGE:error];
           }];
}

#pragma mark ---------- 积分兑换 -----------
- (void)integralrecordexchangeWithIntegral:(NSString *)integral
                                 withMoney:(NSString *)money
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/record/exchange";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"integral"]         = integral;
    parmers[@"money"]            = money;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 使用帮助 -----------
-(void)userHelpSuccess:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"memhelp/lists";
    ShowActionV();
    [self POST:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 工程助手API -----------
/*******************工程助手API*******************/

#pragma mark ---------- 我的订单列表 -----------
/**
 *  我的订单列表
 *
 *  @param status     订单状态 1：报价中；0：已结束
 *  @param keywords   检索词
 *  @param pageNumber 当前页码， 默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)projectGetMyOrderListWithStatus:(NSString *)status
                         keywords:(NSString *)keywords
                       pageNumber:(NSString *)pageNumber
                         pageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/my/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    if (keywords) {
        parmers[@"keywords"]         = keywords;
    }
    if (status) {
        parmers[@"status"]           = status;

    }
//    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
//        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
//        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


/******************* end 工程助手API  end*******************/



#pragma mark ---------- 站长助手API -----------
/*******************站长助手API*******************/
#pragma mark ---------- 检索工程订单 -----------
/**
 *  检索工程订单
 *
 *  @param orderBy      排序，发布时间：orderDate,截止日期：endDate,默认orderDate
 *  @param orderSort    排序，升序：asc,降序：desc,默认desc
 *  @param status       0:已结束，1：报价中，2：已报价
 *  @param orderTypeUid 订单类型ID
 *  @param area         用苗地，Json格式， [{"provinceCode":"11", "cityCode":"110101"},{"provinceCode":"11", "cityCode":"110102"}]
 *  @param pageNumber   当前页码， 默认1
 *  @param pageSize     每页显示数，默认15
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationGetOrderSearchWithOrderBy:(NSString *)orderBy
                               orderSort:(NSString *)orderSort
                                  status:(NSString *)status
                            orderTypeUid:(NSString *)orderTypeUid
                                    area:(NSString *)area
                              pageNumber:(NSString *)pageNumber
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/order/search";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"orderBy"]          = orderBy;
    parmers[@"orderSort"]        = orderSort;
    parmers[@"status"]           = status;
    parmers[@"orderTypeUid"]     = orderTypeUid;
    parmers[@"area"]             = area;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 获取订单类型 -----------
- (void)stationGetOrderTypeSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/ordertype";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 获取质量要求、报价要求、订单类型 -----------
-(void)huiquZhiliangYaoQiuBaoDingSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure

{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/zidian";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 发布工程订单 -----------
-(void)fabuGongChengDingDanWithUid:(NSString *)uid WithprojectName:(NSString *)projectName
                     WithorderName:(NSString *)orderName
                  WithorderTypeUid:(NSString *)orderTypeUid
                  WithusedProvince:(NSString *)usedProvince
                      WithusedCity:(NSString *)usedCity
                       WithendDate:(NSString *)endDate
                  WithchargePerson:(NSString *)chargePerson
                         Withphone:(NSString *)phone
            WithqualityRequirement:(NSString *)qualityRequirement
             WithquotationRequires:(NSString *)quotationRequires
                           Withdbh:(NSString *)dbh
                WithgroundDiameter:(NSString *)groundDiameter
                   Withdescription:(NSString *)description
                              With:(NSString *)itemjson
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/create";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              =uid;
    parmers[@"projectName"]      =projectName;
    parmers[@"orderName"]        =orderName;
    parmers[@"orderTypeUid"]     =orderTypeUid;
    parmers[@"usedProvince"]     =usedProvince;
    parmers[@"usedCity"]         =usedCity;
    parmers[@"endDate"]          =endDate;
    parmers[@"chargePerson"]     =chargePerson;
    parmers[@"phone"]            =phone;
    parmers[@"qualityRequirement"]=qualityRequirement;
    parmers[@"quotationRequires"]=quotationRequires;
    parmers[@"dbh"]              =dbh;
    parmers[@"groundDiameter"]   =groundDiameter;
    parmers[@"description"]      =description;
    parmers[@"itemjson"]         =itemjson;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
/******************* end 站长助手API  end*******************/
-(void)jiaoyanfanhuideshuju:(NSString *)postStr Parmers:(NSDictionary *)parmers
{
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"%@",AFBaseURLString];
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSMutableString *parmStr;
    NSArray *keyArrays = [parmers allKeys];
    for (int i=0; i<keyArrays.count; i++) {
        NSString *keyStr=keyArrays[i];
        NSString *valueStr=parmers[keyStr];
        NSString *tempStr=[NSString stringWithFormat:@"%@=%@",keyStr,valueStr];
        [parmStr appendString:tempStr];
    }
    
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
#pragma mark ---------- 我的订单详情 -----------
-(void)myDingDanDetialWithUid:(NSString *)uid
                 WithPageSize:(NSString *)pageSize
                  WithPageNum:(NSString *)pageNumber
                  Withkeyword:(NSString *)keyword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/my/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        //        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        //        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 我的分享 -----------
-(void)getMyShareSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/invitation";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
//    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
//        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
//        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 报价管理-----------
-(void)baojiaGuanLiWithStatus:(NSString *)status
                  Withkeyword:(NSString *)keyword
               WithpageNumber:(NSString *)pageNumber
                 WithpageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (status) {
        parmers[@"status"]           = status;
    }
    if (keyword) {
         parmers[@"keyword"]          = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
                RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
                RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 报价详情-苗木信息-----------
-(void)baojiaDetialMiaoMuWtihUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/detail/item";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 报价详情-报价信息-----------
-(void)baojiaDetialMessageWithUid:(NSString *)uid
                      WithkeyWord:(NSString *)keyword
                   WithpageNumber:(NSString *)pageNumber
                     WithpageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 站长助手-我的报价 -----------
/**
 *  我的报价
 *
 *  @param status     状态1：已报价；2：已合作；3:已过期；默认所有
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationMyQuoteListWithStatus:(NSString *)status
                         Withkeyword:(NSString *)keyword
                      WithpageNumber:(NSString *)pageNumber
                        WithpageSize:(NSString *)pageSize
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/quote/my/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (status) {
        parmers[@"status"]       = status;
    }
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长助手-检索订单详情 -----------
/**
 *  检索订单详情
 *
 *  @param orderUid 订单ID
 *  @param keyword  检索关键词
 *  @param success  success description
 *  @param failure  failure description
 */
- (void)stationGetOrderDetailWithOrderUid:(NSString *)orderUid
                                  keyword:(NSString *)keyword
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/order/search/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"orderUid"]         = orderUid;
    parmers[@"keyword"]          = keyword;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 建立合作 -----
-(void)jianliHezuoWithBaoJiaID:(NSString *)uid   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/cooperate";
 
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"uid"]              =uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长助手-报价 -----------
/**
 *  报价
 *
 *  @param uid          订单苗木ID
 *  @param orderUid     订单ID
 *  @param price        报价价格
 *  @param quantity     报价数量
 *  @param province     苗圃 省
 *  @param city         苗圃 市
 *  @param county       苗圃 县
 *  @param town         苗圃 镇
 *  @param description  描述
 *  @param imags        大图‘,’分割
 *  @param compressImgs 缩略图‘,’分割
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationQuoteCreateWithUid:(NSString *)uid
                         orderUid:(NSString *)orderUid
                            price:(NSString *)price
                         quantity:(NSString *)quantity
                         province:(NSString *)province
                             city:(NSString *)city
                           county:(NSString *)county
                             town:(NSString *)town
                      description:(NSString *)description
                             imgs:(NSString *)imags
                     compressImgs:(NSString *)compressImgs
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/quote/create";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"uid"]              = orderUid;
    parmers[@"orderUid"]         = uid;
    parmers[@"price"]            = price;
    parmers[@"quantity"]         = quantity;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"town"]             = town;
    parmers[@"description"]      = description;
    parmers[@"imgs"]             = imags;
    parmers[@"compressImgs"]     = compressImgs;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 合作详情 -----
-(void)hezuoDetialWithorderUid:(NSString *)orderUid withitemUid:(NSString *)itemUid
                   WithPageNum:(NSString *)pageNumber
                  WithPageSize:(NSString *)pageSize
                   WithKeyWord:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/cooperate/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
   
    if (orderUid) {
        parmers[@"orderUid"]         = orderUid;
    }
    if (itemUid) {
        parmers[@"itemUid"]      = itemUid;
    }
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
     //#pragma mark ---------- APP设置首次充值最低额度 -----------
     //- (void)getLimitChargeSuccess:(void (^)(id responseObject))success
     //                      failure:(void (^)(NSError *error))failure {
     //    NSString *postURL            = @"getLimitCharge";
     //
     //    [self POST:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
     //
     //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //        success(responseObject);
     //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     //        failure(error);
     //        [HttpClient HTTPERRORMESSAGE:error];
     //    }];
     //
     //}
#pragma mark ---------- 站长中心 -----------
- (void)stationMasterSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/master";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 站长中心编辑 -----------
/**
 *  站长中心编辑
 *
 *  @param chargePerson 负责人
 *  @param phone        电话
 *  @param brief        简介，说明
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationMasterUpdateWithChargePerson:(NSString *)chargePerson
                                      phone:(NSString *)phone
                                      brief:(NSString *)brief
                                    Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/master/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"chargelPerson"]     = chargePerson;
    parmers[@"phone"]            = phone;
    parmers[@"brief"]            = brief;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 金牌供应 -----------
- (void)GoldSupplrWithPageSize:(NSString *)pageSize WithPage:(NSString *)page
              Withgoldsupplier:(NSString *)goldsupplier
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"apisupplyGold";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"page"]            = page;
    parmers[@"pageSize"]        = pageSize;
    parmers[@"goldsupplier"]    = goldsupplier;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的荣誉列表 -----------
/**
 *  我的荣誉列表
 *
 *  @param workstationUid 工作站ID
 *  @param pageNumber     页码，默认1
 *  @param pageSize       每页显示数。默认10
 *  @param success        success description
 *  @param failure        failure description
 */
- (void)stationHonorListWithWorkstationUid:(NSString *)workstationUid
                                pageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 荣誉详情与编辑页信息共用接口 -----------
/**
 *  荣誉详情与编辑页信息共用接口
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDetailWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 荣誉添加 -----------
/**
 *  荣誉添加
 *
 *  @param uid             新增是为空，更新是必传
 *  @param workstationUid  工作站ID
 *  @param name            荣誉名称
 *  @param acquisitionTime 获取时间，格式：yyyy-MM-dd
 *  @param image           荣誉图片
 *  @param success         success description
 *  @param failure         failure description
 */
- (void)stationHonorCreateWithUid:(NSString *)uid
                   workstationUid:(NSString *)workstationUid
                             name:(NSString *)name
                  acquisitionTime:(NSString *)acquisitionTime
                            image:(NSString *)image
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/create";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"name"]             = name;
    parmers[@"acquisitionTime"]  = acquisitionTime;
    parmers[@"image"]            = image;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 荣誉删除 -----------
/**
 *  荣誉删除
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDeleteWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的团队 -----------
/**
 *  我的团队
 *
 *  @param uid        工作站ID
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数。默认10
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationTeamWithUid:(NSString *)uid
                pageNumber:(NSString *)pageNumber
                  pageSize:(NSString *)pageSize
                   keyword:(NSString *)keyword
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/team";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－提交资质升级 -----------
-(void)shengjiGCGSWithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone
     Withzipcode:(NSString *)zipcode
                        Withbrief:(NSString *)brief
                     Withprovince:(NSString *)province
                         Withcity:(NSString *)city
                       Withcounty:(NSString *)county
                      Withaddress:(NSString *)address
                     WithqualJson:(NSString *)qualJson
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apply/company/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"companyName"]      = companyName;
    parmers[@"legalPerson"]      = legalPerson;
    parmers[@"phone"]            = phone;
    parmers[@"brief"]            = brief;
    parmers[@"brief"]            = brief;
    parmers[@"province"]         = province;
    parmers[@"zipcode"]          = zipcode;
    if (city) {
         parmers[@"city"]         = city;
    }
    if (county) {
        parmers[@"county"]        = county;
    }
    parmers[@"address"]         = address;
    parmers[@"qualJson"]        = qualJson;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－工程中心----------
-(void)gongchengZhongXinInfoSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－工程信息编辑----------
-(void)gongchengZhongXinInfoEditWithUid:(NSString *)uid WithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone Withbrief:(NSString *)brief Withprovince:(NSString *)province WithCity:(NSString *)city Withcounty:(NSString *)county
                            WithAddress:(NSString *)address
Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"companyName"]      = companyName;
    parmers[@"legalPerson"]      = legalPerson;
    parmers[@"phone"]            = phone;
    parmers[@"brief"]            = brief;
    parmers[@"brief"]            = brief;
    parmers[@"province"]         = province;
    if (city) {
        parmers[@"city"]         = city;
    }
    if (county) {
        parmers[@"county"]        = county;
    }
    parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程助手－我的资质----------
-(void)GCZXwodezizhiWithuid:(NSString *)uid
             WithpageNumber:(NSString *)pageNumber
               WithpageSize:(NSString *)pageSize
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/list";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]      = uid;
    parmers[@"pageNumber"]      = pageNumber;
    parmers[@"pageSize"]            = pageSize;
  
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－工程助手首页--------
-(void)GCGSshouyeWithPageSize:(NSString *)pageSize WithsupplyCount:(NSString *)supplyCount
WithsupplyNumber:(NSString *)supplyNumber                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/index";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplyCount"]      = supplyCount;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"supplyNumber"]         = supplyNumber;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark ---------- 工程助手－我的资质保存--------
-(void)GCGSRongYuTijiaoWithuid:(NSString *)uid
      WtihcompanyQualification:(NSString *)companyQualification
           WithacquisitionTime:(NSString *)acquisitionTime
                          With:(NSString *)level
                WithcompanyUid:(NSString *)companyUid
          WithissuingAuthority:(NSString *)issuingAuthority
                Withattachment:(NSString *)attachment   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/create";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (uid) {
       parmers[@"uid"]      = uid;
    }
   
    parmers[@"companyQualification"]= companyQualification;
    parmers[@"acquisitionTime"]         = acquisitionTime;
    parmers[@"level"]         = level;
    parmers[@"companyUid"]         = companyUid;
    parmers[@"issuingAuthority"]         = issuingAuthority;
    parmers[@"attachment"]         = attachment;
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－我的资质删除-------
-(void)GCZXDeleteRongYuWithuid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/delete";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
        parmers[@"uid"]      = uid;
    
 
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 工作站列表 -----------
/**
 *  工作站列表
 *
 *  @param province   省
 *  @param city       市
 *  @param county     县
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 */
- (void)stationListWithProvince:(NSString *)province
                           city:(NSString *)city
                         county:(NSString *)county
                        keyword:(NSString *)keyword
                     pageNumber:(NSString *)pageNumber
                       pageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure {

    NSString *postURL            = @"api/company/workstationList";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"keyword"]          = keyword;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;


    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工作站详情 -----------
-(void)workstationdetialWithuid:(NSString *)uid
                 WithpageNumber:(NSString *)pageNumber
                   WithpageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/workstationList/detail";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    
    
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 进入资质审核信息填写页面，获取之前的审核数据-----------
-(void)gongchenggongsiShengheTuiHuiBianJiSuccess:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apply/company/info";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程助手－我的订单基本信息编辑-----------
-(void)wodedingdanbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/my/update";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－订单苗木编辑信息-----------
-(void)dingdanMMbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/updateItem";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－订单苗木更新-----------
-(void)dingdanMMgengxinWithUid:(NSString *)uid
                      WithName:(NSString *)name
                  Withquantity:(NSString *)quantity
                Withdecription:(NSString *)decription Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/doUpdateItem";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"name"]             = name;
    parmers[@"quantity"]         = quantity;
    parmers[@"decription"]       = decription;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－站长供应信息列表-----------
-(void)zhanzhanggongyingListWithPageNum:(NSString *)pageNumber WithPageSize:(NSString *)pageSize WithsearchTime:(NSString *)searchTime
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/supplylist";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]              = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"searchTime"]       = searchTime;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－站长供应信息检索-----------
-(void)ZhanZhanggongyingListWithPage:(NSString*)page
                        WithPageSize:(NSString *)pageSize
                    Withgoldsupplier:(NSString *)goldsupplier
                      WithProductUid:(NSString *)productUid
                     WithProductName:(NSString *)productName
                        WithProvince:(NSString *)province
                            WithCity:(NSString *)city
                          WithCounty:(NSString *)county
                             WithAry:(NSArray *)ary
                      WithSearchTime:(NSString *)searchTime
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/project/supply/search";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parameters[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parameters[@"client_id"]        = kclient_id;
    parameters[@"client_secret"]    = kclient_secret;
    parameters[@"device_id"]        = str;

    parameters[@"pageNumber"]=page;
    parameters[@"pageSize"]=pageSize;
    parameters[@"productName"]=productName;
    
    parameters[@"goldsupplier"]=goldsupplier;
    parameters[@"productUid"]=productUid;
    parameters[@"province"]=province;
    parameters[@"city"]=city;
    parameters[@"county"]=county;
    parameters[@"searchTime"]=searchTime;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 站长中心分享 -----------
- (void)stationShareSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 店铺分享 -----------
- (void)shopShareWithMemberUid:(NSString *)memberUid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"shop/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"memberUid"]        = memberUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 工程中心分享 -----------
- (void)GCZXShareSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 工程公司资质申请状态 -----------
- (void)projectCompanyStatusSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apply/company";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

@end
