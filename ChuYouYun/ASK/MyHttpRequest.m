//
//  MyHttpRequest.m
//  ThinkSNS
//
//  Created by 卢小成 on 14/11/28.
//
//

#define PATH @"/index.php?app=api&mod=Oauth&act=register"


#import "MyHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation MyHttpRequest

+ (void)requestWithURLString:(NSString *)urlStr requestMethod:(NSString *)method parameterDictionary:(NSDictionary *)parameter completion:(void (^)(id))completionBlock
{
    if (!method)
    {
        NSString *getString = @"?";
        for (int i = 0; i < parameter.allKeys.count; i ++)
        {
            
            NSString *keyString = parameter.allKeys[i];
            NSString *valuesString = parameter.allValues[i];
            getString = [getString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keyString,valuesString]];
        }
        NSLog(@"----%@",[NSString stringWithFormat:@"%@%@",urlStr,getString]);
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",urlStr,getString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setCompletionBlock:^{
            completionBlock(request.responseData);
        }];
        [request startAsynchronous];
    }
    else
    {
        NSLog(@"++++++%@",urlStr);
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
        for (int i = 0; i < parameter.allKeys.count ; i ++)
        {
            [request addPostValue:parameter.allValues[i] forKey:parameter.allKeys[i]];
        }
        [request setCompletionBlock:^{
            NSLog(@"----%@",request.responseData);
            completionBlock(request.responseData);
        }];
        
        [request startAsynchronous];
    }
}
@end



@implementation QKHTTPManager



+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_Base_Url]];
}


- (NSString *)URLParamsWithMode:(NSString *)mod act:(NSString *)act
{
    return [API_Base_Url stringByAppendingFormat:@"&mod=%@&act=%@",mod, act];
}
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    return [API_Base_Url stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod,act,oauth_token,oauth_token_secret];
}


//- (NSString *)URLParamsWithMode:(NSString *)mod act:(NSString *)act
//{
//    return [API_Base_Url stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod, act,@"420591e976ca09540022e8c51d16ca73",@"99928518802affe98359b9646cdaca3b"];
//}

- (void)imageVerify:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_SendMsg act:API_Mode_SendMsg_imageVerify];
   
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//获取邮箱验证码
- (void)emailVerification:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_SendMsg act:API_Mode_SendMsg_sendMail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)getService:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_service];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取手机验证码
- (void)phoneVerification:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mod act:API_act_getRegphoneCode];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//手机注册
- (void)phoneZC:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mod act:API_act];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



- (void)codeVerification:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_verifyCode];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//注册协议借口
- (void)getProtocol:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_getProtocol];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];

}

- (void)getPassword:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_resetPwd];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//第三方登陆注册判断
- (void)thirdLogin:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_act];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];

}
/*-----------------------出右云---------*/
//登陆接口
- (void)loginUser:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSString *scheme = [self URLParamsWithMode:API_Mode_Oauth act:API_Mode_Oauth_authorize];
    NSLog(@"==2=====%@",scheme);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//注册
- (void)registUser:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSString *scheme = [self URLParamsWithMode:API_Mod act:API_act];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//出右云讲师列表
-(void)getTeacherList:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_teacher act:API_Mod_GetTeacherList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//讲师筛选
-(void)getTeacherListSX:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_teacher act:API_Mod_searchTeacher];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



//出右云讲师相关课程接口
-(void)getTeacher:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_teacher act:API_Mod_GetTeacher];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//讲师详情 是否关注接口
-(void)getTeacherGZ:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_teacher act:API_Mod_teacherDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



//讲师 添加关注 取消关注 接口
-(void)getTeacherGZOr:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_User act:API_Mod_follow_destroy];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//讲师介绍
-(void)getTeacherDetail:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_teacher act:API_Mod_teacherDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//课程首页开始
-(void)getClass:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_class act:API_Mod_classList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//专辑，课程左上角分类接口
- (void)getCategory:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_category act:API_Mod_categoryList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//问答左上角分类接口
- (void)getAskCategory:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:@"Wenda" act:@"getCate"];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)getClassNoteAndQuestionAndComment:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_class act:API_Mod_noteList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)getClassDetail:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_class act:API_Mod_classDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];

}

//获取免费试看的时间
- (void)getFreeTime:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_Mod_getFreeTime];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
    
}



-(void)getClassDetailssssss:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:api act:api_aa];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)getClassIsvote:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_Mod_DeleteIsvote];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)getClassNoteAndQuestionVote:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_TongWen];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)AddNote:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_AddNote];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)AddReviews:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_AddReviews];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)AddQuestions:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_AddQuestions];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];

}

-(void)collect:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_Collect];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)blum:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_blum act:API_act_blum];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)searchCourse:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_isvote act:API_SearchCourse];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//搜索问答
-(void)searchQuestion:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_Wenda act:API_SearchCourse];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


-(void)albumDetail:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_blum act:API_blumDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)albumCatalog:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_Mod_blum act:API_blumCatalog];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)albumTeacher:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString * scheme = [self URLParamsWithMode:API_blumTeacher act:API_blumTeacherDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//添加收货地址

-(void)addAddress:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act province:(NSString *)province city:(NSString *)city area:(NSString *)area  address:(NSString *)address nanme:(NSString *)nanme phone:(NSString *)phone is_default:(NSString *)is_default success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSString *scheme = [self URLParamsWithMode:mod act:act];
    NSLog(@"===6===%@",scheme);
    NSString *urlStr = [NSString stringWithFormat:@"%@&province=%@&city=%@&area=%@&address=%@&name=%@&phone=%@&is_default=%@",scheme,province,city,area,address,nanme,phone,is_default];
    NSLog(@"===6===%@",urlStr);

    [self GET:urlStr
   parameters:params
      success:success
      failure:failure];
}

//收藏、取消收藏直播
- (void)collectLive:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString * scheme = [self URLParamsWithMode:@"Video" act:API_Collect];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSString *scheme = [self URLParamsWithMode:mod act:act];
    NSLog(@"===6===%@",scheme);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)getTokenpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    /*
     [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
     [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
     [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
     [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
     */
    NSString *scheme = [self URLParamsWithModel:mod act:act oauth_token:@"44da0cedbcda40ce2fabfafb51ae4622" oauth_token_secret:@"34e7b83af30a98d365ec47610761dae1"];
    NSLog(@"===6===%@",scheme);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
@end




