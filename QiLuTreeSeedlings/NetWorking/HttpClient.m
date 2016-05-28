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

//        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
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

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              pageSize,@"pageSize",
                              page,@"page",
                            nil];
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
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              pageSize,@"pageSize",
                              status,@"status",
                              startNumber,@"startNumber",
                              nil];
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/buy/my";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
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
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiuploadios";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                imageString,@"file",
                                @"gongyingtupian.png",@"fileName",
                                nil];
    //NSLog(@"%@",parameters);
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
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
//    for (int i=0; i < array.count; i++) {
//        NSDictionary *dic = array[i];
//        NSString *field =  dic[@"field"];
//        parmers[field]  = [dic objectForKey:@"anwser"];
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
@end
