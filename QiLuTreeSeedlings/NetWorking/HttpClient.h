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
#pragma mark -网络异常判断
+(void)HTTPERRORMESSAGE:(NSError *)errorz;
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
                   WithState:(NSString *)state
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark-个人积分
-(void)getMyIntegralListWithPageNumber:(NSString *)pageNumber
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
                WithusedArea:(NSString *)usedArea
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
- (void)getMysupplyListWithToken:(NSString *)token withAccessId:(NSString *)accessID withClientId:(NSString *)clientID withClientSecret:(NSString *)clientSecret withDeviewId:(NSString *)deviceId withState:(NSString *)state withPage:(NSString *)page withPageSize:(NSString *)pageSize success:(void (^)(id))success failure:(void (^)(NSError *))failure;

#pragma mark-上传图片
-(void)upDataImage:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 上传图片 -----------
-(void)upDataImageIOS:(NSString *)imageString
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
#pragma mark ---------- 收到的我的订制信息 -----------
- (void)getMyCustomizedListInfoWithPageNumber:(NSString *)pageNumber
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure ;
#pragma mark ---------- 我的定制信息列表 -----------
- (void)getCustomSetListInfo:(NSString *)pageNumber
                    pageSize:(NSString *)pageSize
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

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
                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的供应信息修改 -----------
-(void)mySupplyUpdataWithUid:(NSString *)uid
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订制设置保存 -----------
- (void)saveMyCustomizedInfo:(NSString *)uid
                  productUid:(NSString *)productUid
                usedProvince:(NSString *)usedProvince
                    usedCity:(NSString *)usedCity
 withSpecificationAttributes:(NSArray *)etcAttributes
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订制设置修改信息 -----------
- (void)getMyCustomsetEditingWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的供应信息批量删除 -----------
- (void)deleteMySupplyInfo:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息批量删除
- (void)deleteMyBuyInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的定制信息批量删除 -----------
- (void)deleteCustomSetInfo:(NSString *)uids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark 我的苗圃信息批量删除
- (void)deleteMyNuseryInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获得当前用户余额 -----------
- (void)getAmountInfo:(NSString *)nilString
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 是否首次充值 -----------
- (void)isFirstRecharge:(NSString *)nilString
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
#pragma mark 我的收藏猜你喜欢供应列表
-(void)myCollectionYouLikeSupplyWithPage:(NSString *)pageNum
                            WithPageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark 求购联系方式购买
-(void)payForBuyMessageWithBuyUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息关闭
-(void)closeMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购信息打开
-(void)openMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark 我的求购退回原因
-(void)MyBuyMessageReturnReasonWihtUid:(NSString *)Uid
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 购买记录 -----------
- (void)purchaseHistoryWithPage:(NSString *)page
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 购买记录删除 -----------
- (void)purchaseHistoryDeleteWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 手动刷新供应 -----------
- (void)sdsupplybuyrRefreshWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 分享等单条非手动刷新供应 -----------
- (void)supplybuyrRefreshWithUid:(NSString *)uid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 消息列表 -----------
-(void)messageListWithPage:(NSString *)page
              WithPageSize:(NSString *)pageSize
                 WithReads:(NSString *)reads
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 单条消息设置已读 -----------
-(void)myMessageReadingWithUid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 批量消息删除 -----------
-(void)myMessageDeleteWithUid:(NSString *)uids
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 验证手机号是否存在 -----------
-(void)checkPhoneNum:(NSString *)phone
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 忘记密码，验证手机验证码是否正确 -----------
-(void)checkChongzhiPassWorldWihtPhone:(NSString *)phone
                              WithCode:(NSString *)code
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 设置新密码 -----------
-(void)setNewPassWordWithPhone:(NSString *)phone
                  WithPassWord:(NSString *)password
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的供应详情-分享供应 -----------
-(void)supplyShareWithUid:(NSString *)uid
               nurseryUid:(NSString *)nurseryUid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的订制信息 -----------
-(void)customizationUnReadWithPageSize:(NSString *)pageSize
                            PageNumber:(NSString *)pageNumber
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 按产品ID查询订制信息 -----------
- (void)recordByProductWithProductUid:(NSString *)productUid
                            pageSize:(NSString *)pageSize
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 批量删除订制信息（按条） -----------
- (void)deleterecordWithIds:(NSString *)ids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 批量删除订制信息（按树种） -----------
- (void)deleteprorecordWithIds:(NSString *)ids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 按树名获取苗木规格属性 -----------
-(void)huoqumiaomuGuiGeWithTreeName:(NSString *)name
                            andType:(NSString *)type andMain:(NSString *)main
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 求购分享 -----------
/**
 *  求购分享
 *
 *  @param uid     求购UID
 *  @param state   用于求购中 1:热门求购（热门求购中除去已定制和已购买的）；2：我的求购；3：已定制；4：已购买
 *  @param success success description
 *  @param failure failure description
 */
- (void)buyShareWithUid:(NSString *)uid
                  state:(NSString *)state
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 按树名获取苗木规格属性 -----------
-(void)huoqumiaomuGuiGeWithTreeName:(NSString *)name
                            andType:(NSString *)type andMain:(NSString *)main
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;





#pragma mark ---------- 根据关联规格ID获取下一级 -----------
-(void)huoquxiayijiguigeWtithrelation:(NSString *)relation
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 客服系统 -----------
-(void)kefuXiTongWithPage:(NSString *)pageSize
           WithPageNumber:(NSString *)pageNum
               WithIsLoad:(NSString *)isLoad
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
@end
