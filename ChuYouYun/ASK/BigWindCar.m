//
//  BigWindCar.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/25.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "BigWindCar.h"

#import "ZhiyiHTTPRequest.h"
#import "AFNetworking.h"

@implementation BigWindCar


#define API_BigWinCar_URL @"http://el3.51eduline.com/index.php?app=api"

+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BigWinCar_URL]];
}
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act
{
    return [API_BigWinCar_URL stringByAppendingFormat:@"&mod=%@&act=%@",mod,act];
}
#pragma UserToken
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    return [API_BigWinCar_URL stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod,act,oauth_token,oauth_token_secret];
}


//打样 的网络请求
- (void)userLogin:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Login act:BigWinCar_App_Show];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

#pragma mark --- 首页

//首页数据
- (void)BigWinCar_HomeIndex:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_index];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//首页分类数据
- (void)BigWinCar_HomeGetRecCateList:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_getRecCateList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//首页广告图
- (void)BigWinCar_HomeGetAdvert:(NSDictionary *)params
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_getAdvert];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取城市
- (void)BigWinCar_HomeGetArea:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_getArea];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//首页搜索分类
- (void)BigWinCar_HomeGetCateList:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_getCateList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//首页搜索
- (void)BigWinCar_HomeSearch:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_search];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//首页热门搜索
- (void)BigWinCar_HomeGetHotKeyword:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Home act:BigWinCar_App_getHotKeyword];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



#pragma mark --- 机构

//机构列表
- (void)BigWinCar_GetSchoolList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getSchoolList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取用户关注的机构
- (void)BigWinCar_GetMySchoolList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getFollowList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构详情
- (void)BigWinCar_GetSchoolInfo:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getSchoolInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构课程
- (void)BigWinCar_GetSchoolClass:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Video act:BigWinCar_App_videoList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构关注
- (void)BigWinCar_GetFollow_create:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_User act:BigWinCar_App_follow_create];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构取消关注
- (void)BigWinCar_GetFollow_destroy:(NSDictionary *)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_User act:BigWinCar_App_follow_destroy];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



//机构讲师
- (void)BigWinCar_GetSchoolTeacher:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Teacher act:BigWinCar_App_getTeacherList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//判断是否为机构
- (void)BigWinCar_getStatus:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getStatus];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构排课
- (void)BigWinCar_getArrange:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getArrange];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//机构排课每个月的请求
- (void)BigWinCar_getMonthsCourseCount:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getMonthsCourseCount];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//申请机构
- (void)BigWinCar_GetSchoolApply:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_apply];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



#pragma mark --- 课程

//课程章节
- (void)BigWinCar_getClassList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Video act:BigWinCar_App_getCatalog];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//添加学习记录
- (void)BigWinCar_AddRecord:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_User act:BigWinCar_App_addRecord];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取观看记录
- (void)BigWinCar_GetRecord:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_User act:BigWinCar_App_getRecord];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

#pragma mark --- 文库

//文库列表
- (void)BigWinCar_LibiaryList:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Doc act:BigWinCar_App_getDocList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//我的文库
- (void)BigWinCar_LibiaryGetMyDocList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Doc act:BigWinCar_App_getMyDocList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//文库分类
- (void)BigWinCar_LibiaryCategory:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Doc act:BigWinCar_App_getDocCategory];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//文库兑换
- (void)BigWinCar_LibiaryExchange:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Doc act:BigWinCar_App_exchange];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
#pragma mark --- 小组

//小组列表
- (void)BigWinCar_GroupList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组分类
- (void)BigWinCar_GroupCate:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupCate];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组的创建
- (void)BigWinCar_CreateGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_createGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组详情
- (void)BigWinCar_GetGroupInfo:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组评论
- (void)BigWinCar_getGroupTopList:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupTopList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//小组 话题发布
- (void)BigWinCar_groupAddTopic:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_addTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//加入小组
- (void)BigWinCar_joinGroup:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_joinGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//退出小组
- (void)BigWinCar_quitGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_quitGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//编辑小组
- (void)BigWinCar_editGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_editGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//置顶 精华 锁定 收藏 话题
- (void)BigWinCar_operatTopic:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_operatTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取收藏
- (void)BigWinCar_getTopicCollectList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getCollectList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//删除话题
- (void)BigWinCar_deleteTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_deleteTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//话题回复
- (void)BigWinCar_commentTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_commentTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组成员了列表
- (void)BigWinCar_getGroupMember:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupMember];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组成员管理
- (void)BigWinCar_member:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_member];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//解散小组
- (void)BigWinCar_deleteGroup:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_deleteGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

#pragma mark --- 订单

//获取订单
- (void)BigWinCar_getOrder:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_getOrder];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取机构订单
- (void)BigWinCar_getOrderInfo:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getOrderInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//去支付
- (void)BigWinCar_payOrder:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_payOrder];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//去订单详情
- (void)BigWinCar_getOrderDetail:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_getOrder];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}




//获取优惠券
- (void)BigWinCar_getMyCouponList:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Coupon act:BigWinCar_App_getMyCouponList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取优惠券类型
- (void)BigWinCar_getCanUseCouponList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Video act:BigWinCar_App_getCanUseCouponList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//支付课程
- (void)BigWinCar_buyVideos:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Video act:BigWinCar_App_buyVideos];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//支付直播
- (void)BigWinCar_buyZhiBo:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Live act:BigWinCar_App_buyOperating];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//微信支付课程
- (void)BigWinCar_wxpay:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Pay act:BigWinCar_App_wxpay];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//取消订单
- (void)BigWinCar_orderCancel:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_cancel];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//申请退款
- (void)BigWinCar_orderRefund:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_refund];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//删除订单
- (void)BigWinCar_deleteOrder:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Order act:BigWinCar_App_deleteOrder];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

#pragma mark ---- 直播

//删除订单
- (void)BigWinCar_liveCatory:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Live act:BigWinCar_App_deleteOrder];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//直播的今日 明日 请求
- (void)BigWinCar_getLiveByTimespan:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Live act:BigWinCar_App_getLiveByTimespan];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//展示互动 获取 参数
- (void)BigWinCar_getLiveUrl:(NSDictionary *)params
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Live act:BigWinCar_App_getLiveUrl];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}




#pragma mark --- 优惠券领取
- (void)BigWinCar_grantCoupon:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Coupon act:BigWinCar_App_grantCoupon];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//机构的优惠券
- (void)BigWinCar_getCouponList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_School act:BigWinCar_App_getCouponList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//关于我们
- (void)BigWinCar_showAbout:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Public act:BigWinCar_App_showAbout];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


@end
