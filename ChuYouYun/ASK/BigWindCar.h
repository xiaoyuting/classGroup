//
//  BigWindCar.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/25.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface BigWindCar : AFHTTPRequestOperationManager


#define uOauth_token @"[[NSUserDefaults standardUserDefaults]objectForKey:@" oauth_token"]"
#define uOauth_token_secret @"[[NSUserDefaults standardUserDefaults]objectForKey:@" oauth_token_secret"]"

#define API_APP_api @"api"
#define BigWinCar_App_Login @"login"
#define BigWinCar_App_Show @"show"

//首页
#define BigWinCar_App_Home @"Home"
#define BigWinCar_App_index @"index"
#define BigWinCar_App_getRecCateList @"getRecCateList"
#define BigWinCar_App_getAdvert @"getAdvert"
#define BigWinCar_App_getCateList @"getCateList"
#define BigWinCar_App_search @"search"
#define BigWinCar_App_getArea @"getArea"
#define BigWinCar_App_getHotKeyword @"getHotKeyword"

//机构
#define BigWinCar_App_School @"School"
#define BigWinCar_App_getSchoolList @"getSchoolList"
#define BigWinCar_App_getSchoolInfo @"getSchoolInfo"
#define BigWinCar_App_getFollowList @"getFollowList"
#define BigWinCar_App_apply @"apply"
#define BigWinCar_App_getStatus @"getStatus"
#define BigWinCar_App_getArrange @"getArrange"
#define BigWinCar_App_getMonthsCourseCount @"getMonthsCourseCount"
#define BigWinCar_App_follow_create @"follow_create"
#define BigWinCar_App_follow_destroy @"follow_destroy"

//课程
#define BigWinCar_App_Video @"Video"
#define BigWinCar_App_videoList @"videoList"
#define BigWinCar_App_getCatalog @"getCatalog"
#define BigWinCar_App_User @"User"
#define BigWinCar_App_addRecord @"addRecord"
#define BigWinCar_App_getRecord @"getRecord"
#define BigWinCar_App_buyVideos @"buyVideos"



//讲师
#define BigWinCar_App_Teacher @"Teacher"
#define BigWinCar_App_getTeacherList @"getTeacherList"


//文库
#define BigWinCar_App_Doc @"Doc"
#define BigWinCar_App_getDocList @"getDocList"
#define BigWinCar_App_getMyDocList @"getMyDocList"
#define BigWinCar_App_getDocCategory @"getDocCategory"
#define BigWinCar_App_exchange @"exchange"

//小组
#define BigWinCar_App_Group @"Group"
#define BigWinCar_App_getList @"getList"
#define BigWinCar_App_getGroupCate @"getGroupCate"
#define BigWinCar_App_createGroup @"createGroup"
#define BigWinCar_App_getGroupInfo @"getGroupInfo"
#define BigWinCar_App_getGroupTopList @"getGroupTopList"
#define BigWinCar_App_addTopic @"addTopic"
#define BigWinCar_App_joinGroup @"joinGroup"
#define BigWinCar_App_quitGroup @"quitGroup"
#define BigWinCar_App_operatTopic @"operatTopic"
#define BigWinCar_App_getCollectList @"getCollectList"
#define BigWinCar_App_deleteTopic @"deleteTopic"
#define BigWinCar_App_editGroup @"editGroup"
#define BigWinCar_App_getGroupMember @"getGroupMember"
#define BigWinCar_App_member @"member"
#define BigWinCar_App_deleteGroup @"deleteGroup"
#define BigWinCar_App_commentTopic @"commentTopic"

//订单
#define BigWinCar_App_Order @"Order"
#define BigWinCar_App_getOrder @"getOrder"
#define BigWinCar_App_cancel @"cancel"
#define BigWinCar_App_refund @"refund"
#define BigWinCar_App_payOrder @"payOrder"
#define BigWinCar_App_deleteOrder @"deleteOrder"
#define BigWinCar_App_getOrderInfo @"getOrderInfo"

//优惠券
#define BigWinCar_App_Coupon @"Coupon"
#define BigWinCar_App_Live @"Live"
#define BigWinCar_App_getMyCouponList @"getMyCouponList"
#define BigWinCar_App_getCanUseCouponList @"getCanUseCouponList"

//直播
#define BigWinCar_App_Live @"Live"
#define BigWinCar_App_getLiveByTimespan @"getLiveByTimespan"
#define BigWinCar_App_getLiveUrl @"getLiveUrl"
#define BigWinCar_App_buyOperating @"buyOperating"

//优惠券
#define BigWinCar_App_Coupon @"Coupon"
#define BigWinCar_App_grantCoupon @"grantCoupon"
#define BigWinCar_App_getCouponList @"getCouponList"

//支付
#define BigWinCar_App_Pay @"Pay"
#define BigWinCar_App_wxpay @"wxpay"


//个人中心
#define BigWinCar_App_Public @"Public"
#define BigWinCar_App_showAbout @"showAbout"


#pragma mark --- 首页
//首页数据
- (void)BigWinCar_HomeIndex:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//首页分类数据
- (void)BigWinCar_HomeGetRecCateList:(NSDictionary *)params
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//首页广告图
- (void)BigWinCar_HomeGetAdvert:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//首页搜索分类
- (void)BigWinCar_HomeGetCateList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//首页搜索
- (void)BigWinCar_HomeSearch:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//获取城市
- (void)BigWinCar_HomeGetArea:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//首页热门搜索
- (void)BigWinCar_HomeGetHotKeyword:(NSDictionary *)params
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 机构
//机构列表
- (void)BigWinCar_GetSchoolList:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取用户关注的机构
- (void)BigWinCar_GetMySchoolList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//机构详情
- (void)BigWinCar_GetSchoolInfo:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//机构课程
- (void)BigWinCar_GetSchoolClass:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//机构讲师
- (void)BigWinCar_GetSchoolTeacher:(NSDictionary *)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//申请机构
- (void)BigWinCar_GetSchoolApply:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//判断是否为机构
- (void)BigWinCar_getStatus:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//机构排课
- (void)BigWinCar_getArrange:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//机构关注
- (void)BigWinCar_GetFollow_create:(NSDictionary *)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//机构取消关注
- (void)BigWinCar_GetFollow_destroy:(NSDictionary *)params
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//机构排课每个月的请求
- (void)BigWinCar_getMonthsCourseCount:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 课程

//课程章节
- (void)BigWinCar_getClassList:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//添加学习记录
- (void)BigWinCar_AddRecord:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//获取学习记录
- (void)BigWinCar_GetRecord:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//支付课程
- (void)BigWinCar_buyVideos:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 文库

//文库列表
- (void)BigWinCar_LibiaryList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//我的文库
- (void)BigWinCar_LibiaryGetMyDocList:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//文库分类
- (void)BigWinCar_LibiaryCategory:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//文库兑换
- (void)BigWinCar_LibiaryExchange:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 小组

//小组列表
- (void)BigWinCar_GroupList:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组的分类
- (void)BigWinCar_GroupCate:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组的创建
- (void)BigWinCar_CreateGroup:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//小组详情
- (void)BigWinCar_GetGroupInfo:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组话题列表
- (void)BigWinCar_getGroupTopList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组 话题发布
- (void)BigWinCar_groupAddTopic:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//加入小组
- (void)BigWinCar_joinGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//退出小组
- (void)BigWinCar_quitGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//置顶 精华 锁定 收藏 话题
- (void)BigWinCar_operatTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取收藏
- (void)BigWinCar_getTopicCollectList:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//删除话题
- (void)BigWinCar_deleteTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//编辑小组
- (void)BigWinCar_editGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组成员管理
- (void)BigWinCar_member:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组成员了列表
- (void)BigWinCar_getGroupMember:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//解散小组
- (void)BigWinCar_deleteGroup:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//话题回复
- (void)BigWinCar_commentTopic:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 订单

//获取订单
- (void)BigWinCar_getOrder:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//获取机构订单
- (void)BigWinCar_getOrderInfo:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//取消订单
- (void)BigWinCar_orderCancel:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//申请退款
- (void)BigWinCar_orderRefund:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//去支付
- (void)BigWinCar_payOrder:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failur;
//删除订单
- (void)BigWinCar_deleteOrder:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//去订单详情
- (void)BigWinCar_getOrderDetail:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 优惠券

//获取优惠券
- (void)BigWinCar_getMyCouponList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取优惠券类型
- (void)BigWinCar_getCanUseCouponList:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 优惠券领取
- (void)BigWinCar_grantCoupon:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//机构的优惠券
- (void)BigWinCar_getCouponList:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 直播
//直播的今日 明日 请求
- (void)BigWinCar_getLiveByTimespan:(NSDictionary *)params
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//展示互动 获取 参数
- (void)BigWinCar_getLiveUrl:(NSDictionary *)params
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//支付直播
- (void)BigWinCar_buyZhiBo:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 支付
//微信支付课程
- (void)BigWinCar_wxpay:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 个人中心
//关于我们
- (void)BigWinCar_showAbout:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
