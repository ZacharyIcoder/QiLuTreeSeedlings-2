//
//  HttpClient.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/25.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface HttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
#pragma mark -首页
- (void)getHomePageInfoSuccess:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;


#pragma mark -修改个人信息
-(void)changeUserInfoWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
                  WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      withName:(NSString *)name
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark-修改密码
-(void)changeUserPwdWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithOldPassWord:(NSString *)oldPwd
               WithNewPassWord:(NSString *)newPwd
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark-取消苗圃
-(void)cancelMiaoPuWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithIds:(NSString *)ids
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-上传个人头像
-(void)upDataUserImageWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                       WithUserIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-上传图片
-(void)upDataIamge:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
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
                           failure:(void (^)(NSError *error))failure;

#pragma mark-求购信息收藏列表
-(void)collectBuyListWithToken:(NSString *)token
                   WithAccessID:(NSString *)accessID
                   WithClientID:(NSString *)clientID
               WithClientSecret:(NSString *)clientSecret
                   WithDeviceID:(NSString *)deviceID
                       WithPage:(NSString *)page
                   WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark-供应信息收藏列表
-(void)collectSellListWithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-供应信息列表
-(void)SellListWithWithPageSize:(NSString *)pageSize
                    WithPage:(NSString *)page
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-求购信息列表
-(void)BuyListWithWithPageSize:(NSString *)pageSize
                    WithStatus:(NSString *)status
               WithStartNumber:(NSString *)startNumber
                       Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
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
                 failure:(void (^)(NSError *error))failure;
#pragma mark-求购详情
-(void)buyDetailWithUid:(NSString *)uid
           WithAccessID:(NSString *)access_id
               WithType:(NSString *)type
    WithmemberCustomUid:(NSString *)memberCustomUid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark-我的求购编辑
-(void)myBuyEditingWithUid:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark-供应详情
-(void)sellDetailWithUid:(NSString *)uid
            WithAccessID:(NSString *)access_id
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
#pragma mark-热门搜索
-(void)hotkeywordWithkeywordCount:(NSString *)keyWordCount
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

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
                  failure:(void (^)(NSError *error))failure;
#pragma mark-根据苗木名称获取规格属性
-(void)getMmAttributeWith:(NSString *)name
                 WithType:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark-登录
-(void)loginInWithPhone:(NSString *)phone
            andPassWord:(NSString *)passWord
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark-帐号注册
-(void)registeredUserWithPhone:(NSString *)phone
                  withPassWord:(NSString *)password
                withRepassWord:(NSString *)repassword
                      withCode:(NSString *)code
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark-获取短信验证码
-(void)getCodeShotMessageWtihPhone:(NSString *)phone
                           andType:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark-个人信息
-(void)getUserInfoByToken:(NSString *)token
               byAccessId:(NSString *)accessId
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


#pragma mark -退出登录
-(void)logoutInfoByToken:(NSString *)token
              byAccessId:(NSString *)accessId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark -保存供应信息收藏
-(void)collectSupplyWithSupplyNuresyid:(NSString *)nuresyid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark -保存求购信息收藏
-(void)collectBuyWithSupplyID:(NSString *)supply_id
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -取消收藏
-(void)deletesenderCollectWithIds:(NSString *)ids
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark -我的求购列表
-(void)myBuyInfoListWtihPage:(NSString *)page
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

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
                     failure:(void (^)(NSError *error))failure;
#pragma mark -获取企业信息
-(void)getCompanyInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
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
                      failure:(void (^)(NSError *error))failure;

#pragma mark -苗圃列表信息
-(void)getNurseryListWithPage:(NSString *)page
                 WithPageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark -苗圃详情
-(void)nurseryDetialWithUid:(NSString *)uid
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
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
                  failure:(void (^)(NSError *error))failure;

#define HTTPCLIENT [HttpClient sharedClient]

#pragma mark ---------- 供求发布限制 -----------
/**
 *  发布求购和供应信息时，需要判断是否可发布
 *
 *  @param token        AccessToken
 *  @param accessID     用户id
 *  @param clientID     应用的API Key
 *  @param clientSecret 应用的API Secret
 *  @param deviceID     设备ID
 *  @param typeInt      1:求购；2：供应
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)getSupplyRestrictWithToken:(NSString *)token
                            withId:(NSString *)accessID
                      withClientId:(NSString *)clientID
                  withClientSecret:(NSString *)clientSecret
                      withDeviceId:(NSString *)deviceID
                          withType:(NSString *)typeInt
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的供应列表 -----------
/**
 *  我的供应信息列表
 *
 *  @param token        AccessToken
 *  @param accessID     用户id
 *  @param clientID     应用的API Key
 *  @param clientSecret 应用的API Secret
 *  @param deviceId     设备ID
 *  @param page         当前页码（默认显示第一页）
 *  @param pageSize     每页显示条数，（默认15条）
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)getMysupplyListWithToken:(NSString *)token
                    withAccessId:(NSString *)accessID
                    withClientId:(NSString *)clientID
                withClientSecret:(NSString *)clientSecret
                    withDeviewId:(NSString *)deviceId
                        withPage:(NSString *)page
                    withPageSize:(NSString *)pageSize
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

#pragma mark-上传图片
-(void)upDataImage:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 上传图片 -----------
-(void)upDataImageIOS:(UIImage *)image
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取产品分类列表 -----------
- (void)getTypeInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取产品列表 -----------
- (void)getProductWithTypeUid:(NSString *)typeUid
                         type:(NSString *)type
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
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
                              failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 我的供应信息详情 -----------
- (void)getMySupplyDetailInfoWithAccessToken:(NSString *)accesToken
                                    accessId:(NSString *)accessId
                                    clientId:(NSString *)clientId
                                clientSecret:(NSString *)clientSecret
                                    deviceId:(NSString *)deviceId
                                         uid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 我的订制信息 -----------
- (void)getMyCustomizedListInfoWithPageNumber:(NSString *)pageNumber
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 消费记录 -----------
- (void)getConsumeRecordInfoWithPageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 微信支付 -----------
- (void)weixinPayOrder:(NSString *)price
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
;
#pragma mark ---------- 银联获取tn交易号方法 -----------
- (void)getUnioPay:(NSString *)price
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
- (void)getUnioPayTnString:(NSString *)price
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure ;
@end
