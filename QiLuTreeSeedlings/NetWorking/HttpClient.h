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

#pragma mark -版本检测
-(void)getVersionSuccess:(void (^)(id responseObject))success
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
               Withgoldsupplier:(NSString *)goldsupplier
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
//-(void)upDataImageIOS:(NSString *)imageString
//              Success:(void (^)(id responseObject))success
//              failure:(void (^)(NSError *error))failure;
//-(void)upDataImageIOS:(NSString *)imageString
//       workstationUid:(NSString *)workstationUid
//                 type:(NSString *)type
//              Success:(void (^)(id responseObject))success
//              failure:(void (^)(NSError *error))failure;
/**
 *  上传图片
 *
 *  @param imageString    imageString description
 *  @param workstationUid 工作站ID，添加站长头像时，必传
 *  @param companyUid     企业ID，工程公司上传头像时，必传
 *  @param type           默认1，1 供应上传(原图、缩略图、详情图，加水印)；2：站长头像上传（原图）；3：工作站荣誉/报价（原图/缩略图）
 *  @param saveType       保存类型，默认1,；
 1:默认不保存，2：app头像上传（原图），3：工程公司头像

 *  @param success        {
	"result":
 {
 "url":"xxx.jpg",	--原图
 "compressurl":"xxx-compress.jpg"	--压缩图
 "detailurl":"xxx-detail.jpg"	--详情轮播图
 },
	"success":true
 }
 *  @param failure        {
	"error_code":"500",
	"msg":"文件上传失败",
	"success":false
 }

 */
-(void)upDataImageIOS:(NSString *)imageString
       workstationUid:(NSString *)workstationUid
           companyUid:(NSString *)companyUid
                 type:(NSString *)type
             saveTyep:(NSString *)saveType
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
/**
 *  微信支付
 *
 *  @param price        总金额
 *  @param supplyBuyUid Type=1 时必传，求购ID
 *  @param type         不传默认为0;代表充值 1代表微信单条购买
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)weixinPayOrder:(NSString *)price
          supplyBuyUid:(NSString *)supplyBuyUid
                  type:(NSString *)type
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

#pragma mark ---------- 积分兑换规则 -----------
- (void)integraRuleSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 积分兑换 -----------
- (void)integralrecordexchangeWithIntegral:(NSString *)integral
                                 withMoney:(NSString *)money
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

/*******************工程助手API*******************/

#pragma mark ---------- 使用帮助 -----------
-(void)userHelpSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

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
                          failure:(void (^)(NSError *error))failure;


/******************* end --工程助手API--  end *******************/

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
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 获取订单类型 -----------
- (void)stationGetOrderTypeSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/******************* end--站长助手API--end *******************/
#pragma mark ---------- 获取质量要求、报价要求、订单类型 -----------
-(void)huiquZhiliangYaoQiuBaoDingSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 发布工程订单 -----------
-(void)fabuGongChengDingDanWithorderName:(NSString *)orderName
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
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的订单详情 -----------
-(void)myDingDanDetialWithUid:(NSString *)uid
                 WithPageSize:(NSString *)pageSize
                 WithPageNum:(NSString *)pageNumber
                 Withkeyword:(NSString *)keyword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 我的分享 -----------
-(void)getMyShareSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价管理-----------
-(void)baojiaGuanLiWithStatus:(NSString *)status
                  Withkeyword:(NSString *)keyword
               WithpageNumber:(NSString *)pageNumber
                 WithpageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 报价详情-苗木信息-----------
-(void)baojiaDetialMiaoMuWtihUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价详情-报价信息-----------
-(void)baojiaDetialMessageWithUid:(NSString *)uid
                      WithkeyWord:(NSString *)keyword
                   WithpageNumber:(NSString *)pageNumber
                     WithpageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
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
                             failure:(void (^)(NSError *error))failure;
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
                                  failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 建立合作 -----
-(void)jianliHezuoWithBaoJiaID:(NSString *)uid   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 合作详情 -----
-(void)hezuoDetialWithorderUid:(NSString *)orderUid withitemUid:(NSString *)itemUid
                   WithPageNum:(NSString *)pageNumber
                  WithPageSize:(NSString *)pageSize
                   WithKeyWord:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 报价详情-苗木信息 -----
//-(void)hezuoDetialMiaoMuXiXi

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
                          failure:(void (^)(NSError *error))failure;
//#pragma mark ---------- APP设置首次充值最低额度 -----------
//- (void)getLimitChargeSuccess:(void (^)(id responseObject))success
//failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 站长中心 -----------
- (void)stationMasterSuccess:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

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
                                    failure:(void (^)(NSError *error))failure;


#pragma mark ---------- 金牌供应 -----------
- (void)GoldSupplrWithPageSize:(NSString *)pageSize WithPage:(NSString *)page
              Withgoldsupplier:(NSString *)goldsupplier
                Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

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
                                   failure:(void (^)(NSError *error))failure;

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
                          failure:(void (^)(NSError *error))failure;

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
                          failure:(void (^)(NSError *error))failure;

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
                          failure:(void (^)(NSError *error))failure;

#pragma mark ---------- 我的团队 -----------
/**
 *  我的团队
 *
 *  @param uid        工作站ID
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数。默认10
 *  @param keyword    检索词
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationTeamWithUid:(NSString *)uid
                pageNumber:(NSString *)pageNumber
                  pageSize:(NSString *)pageSize
                   keyword:(NSString *)keyword
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－提交资质升级 -----------
-(void)shengjiGCGSWithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone
                        Withbrief:(NSString *)brief
                     Withprovince:(NSString *)province
                         Withcity:(NSString *)city
                       Withcounty:(NSString *)county
                      Withaddress:(NSString *)address
                     WithqualJson:(NSString *)qualJson
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－工程中心----------
-(void)gongchengZhongXinInfoSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－企业信息编辑----------
-(void)gongchengZhongXinInfoEditWithUid:(NSString *)uid WithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone Withbrief:(NSString *)brief Withprovince:(NSString *)province WithCity:(NSString *)city Withcounty:(NSString *)county
                            WithAddress:(NSString *)address
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质----------
-(void)GCZXwodezizhiWithuid:(NSString *)uid
             WithpageNumber:(NSString *)pageNumber
               WithpageSize:(NSString *)pageSize
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－工程助手首页--------
-(void)GCGSshouyeWithPageSize:(NSString *)pageSize WithsupplyCount:(NSString *)supplyCount
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质保存--------
-(void)GCGSRongYuTijiaoWithuid:(NSString *)uid
      WtihcompanyQualification:(NSString *)companyQualification
           WithacquisitionTime:(NSString *)acquisitionTime
                          With:(NSString *)level
                WithcompanyUid:(NSString *)companyUid
          WithissuingAuthority:(NSString *)issuingAuthority
                Withattachment:(NSString *)attachment   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工程助手－我的资质删除-------
-(void)GCZXDeleteRongYuWithuid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

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
 *  @param success    {
 "result":{
 "workStationList":[
 {
 "area":"山东临沂河东区汤河镇",	--地区
 "chargelPerson":"邢明龙",	--联系人
 "phone":"18265391071",	--联系电话
 "uid":"4A367CD4-8B46-4279-B7D1-015E9FECAEE6",	--工作站ID
 "viewNo":"鲁 第0001号",	--工作站编号
 "workstationName":"0001"	--工作站名称
 },
 {
 ......
 }
 ]
 },
 "success":true
 }

 *  @param failure    {
	"error_code":"500",
	"msg":"",
	"success":false
 }

 */
- (void)stationListWithProvince:(NSString *)province
                           city:(NSString *)city
                         county:(NSString *)county
                        keyword:(NSString *)keyword
                     pageNumber:(NSString *)pageNumber
                       pageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
#pragma mark ---------- 工作站详情-----------
//{
//    "result":{
//        "supplyList":[	--供应信息
//                      {
//                          "count":"1",
//                          "createTime":"2016-05-28 09:20:31",
//                          "edit":false,
//                          "goldsupplier":0,
//                          "image":"http://123.56.229.197:8082/qlmm//static/upload/attachment/member/image/201605/d7f3abe0-b220-411a-b2f3-1b6c547c2a57-compress.jpg",
//                          "price":"面议",
//                          "reason":"",
//                          "shuaxin":false,
//                          "state":0,
//                          "title":"湖北地区8-15公分栾树",
//                          "tuihui":false,
//                          "uid":"FCFF44D3-D6F0-44F7-872A-26FBE1A9CFA8"
//                      },
//                      {
//                          ......
//                      }
//                      ],
//        "masterInfo":{	--工作站信息，第一页返回数据，其他页不返回
//            "area":"山东省临沂市莒南县板泉镇",	--地区
//            "brief":"",	--简介
//            "chargelPerson":"李传刚",	--联系人
//            "creditMargin":"0.00",	--保证金
//            "phone":"18265391071",
//            "type":"分站",
//            "uid":"68699F89-D71C-4B84-A728-416A47F9A57D",
//            "viewNo":"鲁 第0003号",	--工作站编号
//            "workstationName":"012",	--工作站名称
//            "workstationPic":""	--工作站头像
//        }
//    },
//    "success":true
//}
-(void)workstationdetialWithuid:(NSString *)uid
                 WithpageNumber:(NSString *)pageNumber
                   WithpageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
@end
