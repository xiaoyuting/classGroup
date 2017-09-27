//
//  MyHttpRequest.h
//  ThinkSNS
//
//  Created by 卢小成 on 14/11/28.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ASIHTTPRequest.h"
//#import "RegisterModel.h"
#define API_Base_Url @"http://el3.51eduline.com/index.php?app=api"
#define GLAPI_Base_Url @"http://el3.51eduline.com"

@interface MyHttpRequest : NSObject

{
    ASIHTTPRequest *_request;
}

/*
 urlStr URL地址
 method 请求方式   GET／POST
 parameter 详细URL参数拼接
 
 */
+ (void)requestWithURLString:(NSString *)urlStr requestMethod:(NSString *)method parameterDictionary:(NSDictionary *)parameter completion:(void (^) (id obj))completionBlock;

@end

//出右云

//注册
#define API_Mod @"Login"
#define API_act @"app_regist"
//手机号验证
#define API_act_clickPhoneCode @"clickPhoneCode"

//获取验证码
#define API_Pact @"getRegphoneCode"

//讲师列表首页
#define API_Mod_teacher @"Teacher"

#define API_Mod_searchTeacher @"searchTeacher"

//用户
#define API_Mod_User @"User"

//用户关注 或者 取消关注
#define API_Mod_follow_destroy @"follow_destroy"

#define API_Mod_GetTeacherList @"getTeacherList"
//讲师详情
#define API_Mod_GetTeacher @"teacherVideoList"
#define API_Mod_teacherDetail @"getTeacher"
//课程首页
#define API_Mod_class @"Video"
#define API_Mod_classList @"videoList"
//课程和专辑分类
#define API_Mod_category @"Video"
#define API_Mod_categoryList @"getVideoGroup"
//获取课程笔记，提问，点评
#define API_Mod_noteList @"render"
//课程详情
#define API_Mod_classDetail @"videoInfo"

#define API_Mod_getFreeTime @"getFreeTime"

//课程点评点赞、取消赞接口
#define API_Mod_isvote @"Video"

#define API_Mod_Wenda @"Wenda"

#define API_Mod_DeleteIsvote @"doreviewvote"
//课程提问、笔记点赞接口
#define API_TongWen @"tongwen"
//添加课程笔记
#define API_AddNote @"addNote"
//添加课程提问
#define API_AddQuestions @"addQuestion"

//添加课程点评
#define API_AddReviews @"addReview"

//收藏、取消收藏课程
#define API_Collect @"collect"
//专辑首页
#define API_Mod_blum @"Album"
#define API_act_blum @"getAlbumList"
//根据内容搜索课程
#define API_SearchCourse @"strSearch"
//专辑详情
#define API_blumDetail @"albumView"
//专辑章节
#define API_blumCatalog @"getCatalog"
//专辑讲师接口
#define API_blumTeacher @"Teacher"
#define API_blumTeacherDetail @"groupTeacherList"
//青稞
#define API_Mode_Oauth @"Oauth"


#define API_Mode_Oauth_register @"register"     //用户注册接口
#define API_Mode_Oauth_authorize @"authorize"   //登陆接口
//修改密码验证码接口
#define API_Mode_Oauth_verifyCode @"verifyCode"
//注册协议接口
#define API_Mode_Oauth_getProtocol @"getProtocol"
//设置密码
#define API_Mode_Oauth_resetPwd @"resetPwd"
//获取客服电话
#define API_Mode_Oauth_service @"service"

//获取验证码接口
#define API_Mode_SendMsg @"SendMsg"
//获取图片验证码
#define API_Mode_SendMsg_imageVerify @"imageVerify"
//获取邮件验证码
#define API_Mode_SendMsg_sendMail @"sendMail"
//获取手机验证码
#define API_Mode_SendMsg_sendMsg @"sendMsg"

#define api @"Video"
#define api_aa @"getCollectVideoList"

#define API_act_getRegphoneCode @"getRegphoneCode"

//第三方登陆判断是否注册
#define API_Mode_Oauth_act @"verifyReg"

@interface QKHTTPManager : AFHTTPRequestOperationManager

+ (instancetype)manager;



#pragma mark - 注册
/**
 *  手机注册API
 *
 *  @param user    RegisterModel类对象
 *  @param success 成功回调代码快
 *  @param failure 失败回调代码块
 */
//登陆
// 获取图片验证码
- (void)imageVerify:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取邮箱验证码
- (void)emailVerification:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//获取客服电话
- (void)getService:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取手机验证码
- (void)phoneVerification:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//找回密码下一步验证
- (void)codeVerification:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//注册协议借口
- (void)getProtocol:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//设置密码
- (void)getPassword:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//第三方登陆注册判断
- (void)thirdLogin:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//出右云
- (void)loginUser:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



- (void)registUser:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




//讲师列表首页
- (void)getTeacherList:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//讲师相关课程
- (void)getTeacher:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//讲师介绍
- (void)getTeacherDetail:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//课程首页
- (void)getClass:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//课程专辑分类接口
- (void)getCategory:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//课程详情页面笔记、提问、点评
- (void)getClassNoteAndQuestionAndComment:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//课程详情
- (void)getClassDetail:(NSDictionary *)params
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getClassDetailssssss:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//课程点评点赞、取消赞接口
- (void)getClassIsvote:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//课程提问、笔记点赞接口
- (void)getClassNoteAndQuestionVote:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//添加课程笔记
- (void)AddNote:(NSDictionary *)params
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//添加课程提问
- (void)AddQuestions:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//添加点评
- (void)AddReviews:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//收藏、取消收藏课程
- (void)collect:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//专辑首页
- (void)blum:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//根据内容搜索课程
- (void)searchCourse:(NSDictionary *)params
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//专辑列表
- (void)albumDetail:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//专辑目录
- (void)albumCatalog:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//专辑讲师
- (void)albumTeacher:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//搜索问答
-(void)searchQuestion:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


-(void)getTeacherListSX:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


//讲师是否关注接口
-(void)getTeacherGZ:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


//讲师关注 取消关注接口
-(void)getTeacherGZOr:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


- (void)phoneZC:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getFreeTime:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)getAskCategory:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
//添加收货地址
-(void)addAddress:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act province:(NSString *)province city:(NSString *)city area:(NSString *)area  address:(NSString *)address nanme:(NSString *)nanme phone:(NSString *)phone is_default:(NSString *)is_default success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)getTokenpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//公用，需要传入oauth_token
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret;

//收藏、取消收藏直播
- (void)collectLive:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end





