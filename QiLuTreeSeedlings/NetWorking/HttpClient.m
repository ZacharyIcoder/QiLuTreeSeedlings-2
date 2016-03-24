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
        _sharedClient.requestSerializer.timeoutInterval = 10.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return _sharedClient;
}
#pragma mark -首页
- (void)getHomePageInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apiindex";
        NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                  @"10",@"keywordCount",
                                  @"10",@"recommendCount",
                                   @"5",@"supplyCount", nil];
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    NSString *postURL = @"api/updatename";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              name,@"name",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    NSString *postURL = @"api/modifypassword";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              oldPwd,@"oldPassword",
                              newPwd,@"plainPassword",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    NSString *postURL = @"fileUpload/uploadphoto";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              nil];
    NSData *iconData=UIImageJPEGRepresentation(image, 0.1);
    [self POST:postURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:iconData name:@"uploadFile"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
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
    NSString *postURL = @"api/wrokStationListoutme";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              workstationUId,@"workstationUId",
                              areaCode,@"areaCode",
                              page,@"page",
                              pageSize,@"pageSize",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
        [parameters setObject:[dic objectForKey:@"anwser"] forKey:[dic objectForKey:@"field"]];
    }
  // NSLog(@"%@",parameters);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
#pragma mark-求购详情
-(void)buyDetailWithUid:(NSString *)uid
           WithAccessID:(NSString *)access_id
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy/detail";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                            uid,@"uid",
                            access_id,@"access_id",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
        [parameters setObject:[dic objectForKey:@"anwser"] forKey:[dic objectForKey:@"field"]];
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    //NSLog(@"%@",parameters);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    NSLog(@"%@",str);
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
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)collectSupplyWithSupplyNuresyid:(NSString *)nuresyid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
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
    }];

}
#pragma mark -保存求购信息收藏
-(void)collectBuyWithSupplyID:(NSString *)supply_id
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
    NSString *postURL = @"/api/collect/buy/save";
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
    }];

}
#pragma mark -我的求购列表
-(void)myBuyInfoListWtihPage:(NSString *)page
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
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
            WithUsedProvince:(NSString *)usedProvince
                WithUsedCity:(NSString *)city
              WithUsedCounty:(NSString *)usedCounty
                     WithAry:(NSArray  *)ary
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
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
    if (usedProvince) {
        [parameters setObject:usedProvince forKey:@"usedProvince"];
    }
    if (city) {
        [parameters setObject:city forKey:@"usedCity"];
    }
    if (usedCounty) {
        [parameters setObject:usedCounty forKey:@"usedCounty"];
    }
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"anwser"] forKey:[dic objectForKey:@"field"]];
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
    //NSLog(@"%@",parameters);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
    }];

}
@end
