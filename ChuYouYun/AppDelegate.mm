//
//  AppDelegate.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "AppDelegate.h"
#import "rootViewController.h"
#import "blumViewController.h"
#import "classViewController.h"
#import "teacherViewController.h"
#import "questionViewController.h"
#import "MyViewController.h"
#import "UserLoginViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "EMSDKFull.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DLViewController.h"
#import "Reachability.h"
#import <PlayerSDK/GSDiagnosisInfo.h>
#import "HcdGuideView.h"
#import "BBLaunchAdMonitor.h"
#import "AdViewController.h"

#import "BigWindCar.h"


//网络下载
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#define APP_ID @""
#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)
#define SWToStr(X) [SingleCenterObj replaceNilStr:X nilStr:@""]
#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)
//avatar
#define SWUID [UserModel uid]
#define SWUNAME [UserModel uname]
#define SWAVATAR [UserModel avatar]
#define SWINTRO [UserModel intro]
#define IsAdminer [UserModel isAdmin]

//聊天相关的通知
#define Chat_SocketStateNotification @"socketefstatenoti"//socket的连接状态
#define Chat_UpdateNotisCountNotification @"updateMessageCountfdsafdsk231"//更新消息个数
#define Chat_ChatRoomListGetNotification @"fjnchat,,,fs"//聊天室列表
#define Chat_UpdateChatRoomTableNotification @"fixReloadTbaleViewfds"//刷新聊天室列表，参数是对应的room_id
#define Chat_UpdateChatRoomMessageNotifaction @"UpdateChatRoomMessageNotifaction" //新消息，刷新聊天室列表的显示，需要重新排序不同于上面的一个通知
#define Chat_RoomHeadChangeNotification @"jdfsaChat_roomenHad"//聊天室头像改变通知,socket发出来的
#define Chat_RoomNameChangeNotification @"roomnamebbdksf"//聊天室名字改变
#define Chat_RoomAddUserNotification @"Chat_RoomAddUserNotification"//添加了新的成员
#define Chat_QuitRoomNotification @"quit_group_roomfds77afds"//退出聊天室
#define Chat_InputingStateNotifaciton @"shuruzhuangtaigabina"//输入状态改变
#define Chat_GetRoomInfoNotification @"huoqufangjianxinxi"//获取房间信息
#define Chat_CreateGroupRoomNotification @"creatGroupRoofdsa121m"//创建群组聊天
#define Chat_SendMessageBackNotification @"fasongliaothuidiao"//发送聊天信息回调
#define Chat_SendMessageDealBackNotification @"fsdachatdeatk1"//发送的聊天消息回调本地处理完毕了
#define Chat_DeleteChatRoomChatInfoNotification @"chcakjfhdekege"//清空聊天信息
#define Chat_GetNewMessagesNotification @"jkjgetnesfff"//获取到了新的聊天信息,品种有点多，供多种玩味
#define Chat_GetMessageListNotfication @"getmessagelistss"//获取聊天的聊天记录列表
#define Chat_GetMessageLatestReloadUINotificaiton @"Chat_GetMessageLatestReloadUINotificaiton"//获得了聊天记录，用来刷
#define Chat_ReloadKeepKeyName @"goMyTableViewReloadData" //保持刷新数据后，界面保持在当前位置的一个本地化key值
#define Chat_UploadImageProgressNotification @"Chat_UploadImageProgressNotification"//上传图片的进度通知
#define Chat_RefreshChatUnreadCountNotification @"Chat_RefreshChatUnreadCountNotification"//刷新未读聊天个数
#define Chat_IsLoginRefreshRoomListNotification @"Chat_IsLoginRefreshRoomListNotification"//登录了之后刷新聊天室列表
//聊天服务器配置
#define CHAT_URL [NSString stringWithFormat:@"ws://%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"socketUrl"]]
@interface AppDelegate ()
{
    blumViewController * blum;
@private Reachability *hostReach;


}
@property (nonatomic, copy) NSString *_iTunesLink;

@end

@implementation AppDelegate




- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}



+(AppDelegate *)delegate
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (rootViewController *)rootVC
{
    return (rootViewController *)window.rootViewController;
}

-(void)onCheckVersion:(NSString *)currentVersion
{
    NSString *URL = [ NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APP_ID];;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    if (error != nil)
    {
        return;
    }
    NSData *data = [results dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count])
    {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        NSString *trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
        self._iTunesLink = [NSString stringWithFormat:@"%@%@",@"itms-apps:",[trackViewURL substringFromIndex:6]];
        if (![lastVersion isEqualToString:currentVersion])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本，是否前往更新？" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
            alert.tag = 2;
            [alert show];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [self NetWorkGetAd];
    //延长启动图的展示时间方法
     [NSThread sleepForTimeInterval:2.0];
    self.window.backgroundColor = [UIColor whiteColor];
    [UMSocialData setAppKey:@"574e8829e0f55a12f8001790"];

    //QQ
    [UMSocialQQHandler setQQWithAppId:@"101400042" appKey:@"a85c2fcd67839693d5c0bf13bec84779" url:@"http://www.umeng.com/social"];
    
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    //微信
     [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:@"https://itunes.apple.com/cn/app/she-bao-ji-suan-qi/id1076882526?mt=8"];
    //注册APPID
    [WXApi registerApp:@"wxbbb961a0b0bf577a" withDescription:@"云课堂"];
    //隐藏未安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    //网络下载
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    httpServer = [[HTTPServer alloc] init];
    
    [httpServer setType:@"_http._tcp."];
    
    [httpServer setPort:12345];
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
    
    self._allowRotation = NO;
//    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"]) {
//        UserLoginViewController *login = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
//        self.window.rootViewController = login;
//        
//        DLViewController *DLVC = [[DLViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
//        self.window.rootViewController = nav;
//    }else
//    {
//        rootViewController * tabbar = [[rootViewController alloc]init];
//        self.window.rootViewController = tabbar;
//    }
    
    rootViewController * tabbar = [[rootViewController alloc]init];
    self.window.rootViewController = tabbar;

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"douser#istore" apnsCertName:@"istore_dev"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self.window makeKeyAndVisible];

    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"new_feature_1-667h@2x.png"]];
    [images addObject:[UIImage imageNamed:@"new_feature_2-667h@2x.png"]];
    [images addObject:[UIImage imageNamed:@"new_feature_4-667h@2x.png"]];
    
    HcdGuideView *guideView = [HcdGuideView sharedInstance];
    guideView.window = self.window;
    [guideView showGuideViewWithImages:images
                        andButtonTitle:@""
                   andButtonTitleColor:[UIColor clearColor]
                      andButtonBGColor:[UIColor clearColor]
                  andButtonBorderColor:[UIColor clearColor]];
    
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdImageUrl:) name:BBLaunchAdDetailImageUrlNotification object:nil];
//    
//
//    
//    NSString *path = @"http://mg.soupingguo.com/bizhi/big/10/258/043/10258043.jpg";
//
//    
//    [BBLaunchAdMonitor  showAdAtPath:path onView:self.window timeInterval:5 detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"}];
    
    
//    [self NetWorkGetAd];
    
    
    
    return NO;
}


- (void)NetWorkGetAd {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:@"app_ad" forKey:@"place"];
    [manager BigWinCar_HomeGetAdvert:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        
        NSString *bannerStr = responseObject[@"data"][@"banner"];
        
        NSString *bannerUrl = responseObject[@"data"][@"bannerurl"];
        
        if (bannerStr != nil) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdImageUrl:) name:BBLaunchAdDetailImageUrlNotification object:nil];
            
            
            NSString *path = bannerStr;
            if ([bannerUrl isEqualToString:@""]) {
                 [BBLaunchAdMonitor  showAdAtPath:path onView:self.window timeInterval:5 detailParameters:@{@"carId":@(12345), @"url":@"123"}];
            } else {
                 [BBLaunchAdMonitor  showAdAtPath:path onView:self.window timeInterval:5 detailParameters:@{@"carId":@(12345), @"url":bannerUrl}];
            }

        } else  {
            
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];


    
}




- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
}

- (void)showAdImageUrl:(NSNotification *)noti {
     NSLog(@"detail url:%@", noti.object);
    NSDictionary *dict = noti.object;
    AdViewController *adVc = [[AdViewController alloc] init];
//    adVc.adStr = @http://www.audi.cn/cn/web/zh.html?csref=sea_161228_145607_baidu_p_bz_1612_audi&smtid=487832398z1uo8zyln2z1pdz0zMg%3D%3D"";
    
    adVc.adStr = [NSString stringWithFormat:@"%@",dict[@"url"]];

    [self.window.rootViewController presentViewController:adVc animated:YES completion:nil];
    
}


//重写AppDelegate  handleOpenURL openURL
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

  //  return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kReachableViaWWAN){
        printf("\n3g/2G\n");
    }
    else if(status == kReachableViaWiFi){
        printf("\nwifi\n");
    }else{
        printf("\n无网络\n");
    }
    
}


//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    return YES;
//    return [UMSocialSnsService handleOpenURL:url];
//}

//使用第三方登录需要重写下面两个方法
//Alipay
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
    }
    return result;
 }


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [UMSocialSnsService handleOpenURL:url];
}


/**
 *  及时通讯
 *
 *  @param application <#application description#>
 */
#pragma mark - SRWebSocket调用方法
- (void)reconnect
{
    _webSocket.delegate = nil;
    [_webSocket close];
    if (SWNOTEmptyStr([[NSUserDefaults standardUserDefaults] objectForKey:@"socketUrl"])) {
        
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CHAT_URL]]];
        _webSocket.delegate = self;
        [_webSocket open];
    }
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
   // if ([SWUNAME length]>0&&[SWUID length]>0&&[[UserModel oauthToken] length]>0) {
        if (1) {
        //send的参数需要是Json格式的字符串
        NSDictionary *dic = @{@"type":@"login",@"uid":@"38347",@"oauth_token":@"2d8af6cba5096870fc4234cfdfe9f477",@"oauth_token_secret":@"15286b3b8a4565a2ffd2588a88ac758a"};
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [_webSocket send:string];
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [_webSocket close];
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    //返回的数据是Json格式的字符串,需要将其解析出来
    id result = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]])
    {
        //[NSThread sleepForTimeInterval:1];
        if ([[result objectForKey:@"type"]isEqualToString:@"login"]) {
            //app已登录状态，对socket的登录状态进行操作
            if (1) {
                if ([result[@"status"]integerValue]==1003) {
                    //未登录/冲连接
                    [self reconnect];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_IsLoginRefreshRoomListNotification object:nil];
                    //shareChat.wsConnet = YES;//已连接
                    long ftime = time(NULL);
                    _ftime = ftime;
                }
            }
        }else if ([[result objectForKey:@"type"]isEqualToString:@"connect"]) {
            //连接成功
        }else if ([[result objectForKey:@"type"] isEqualToString:@"ping"]){
            //通过心跳确定与服务器是否正常连接
            if (_reGetSWRespone) {
                //检查重发队列
               // [shareChat startRePostMessageQueue];
                _reGetSWRespone = NO;
            }
            long ftime = time(NULL);//与上句等价
            _ftime = ftime;
            //            NSLog(@"最近心跳时间：%@",[NSDate date]);
            NSDictionary *dic = @{@"type":@"pong"};
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [_webSocket send:string];
            return;
        }
        //收到聊天消息
        else if ([[result objectForKey:@"type"] isEqualToString:@"say"])
        {
        }
        else if ([[result objectForKey:@"type"] isEqualToString:@"group"])
        {
        }
        else if ([[result objectForKey:@"type"] isEqualToString:@"input_status"]) {
            //输入状态的改变
            [[NSNotificationCenter defaultCenter]postNotificationName:Chat_InputingStateNotifaciton object:result];
        }
        else if ([[result objectForKey:@"type"] isEqualToString:@"quit_group_room"])
        {
            //退出聊天室
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_QuitRoomNotification object:result];
           // [shareChat requestRoomList:nil];
        }
        else if ([[result objectForKey:@"type"] isEqualToString:@"get_room_list"])
        {
            //获取聊天室列表
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_ChatRoomListGetNotification object:result];
        }
        else if ([[result objectForKey:@"type"] isEqualToString:@"get_room"])
        {
            //获取聊天室信息
            [[NSNotificationCenter defaultCenter]postNotificationName:Chat_GetRoomInfoNotification object:result];
        }
        else if ([[result objectForKey:@"type"]isEqualToString:@"create_group_room"])
        {
            //创建聊天室
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_CreateGroupRoomNotification object:result];
            //[shareChat requestRoomList:nil];
        }else if ([[result objectForKey:@"type"]isEqualToString:@"add_group_member"]){
            //添加群成员
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_RoomAddUserNotification object:result];
        }
        else if ([[result objectForKey:@"type"]isEqualToString:@"set_room"])
        {
            //设置群组聊天房间
            if ([[[result objectForKey:@"result"] objectForKey:@"group_type"]intValue] ==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setGroupRoom" object:result];
                //改变群组聊天的名字
                [[NSNotificationCenter defaultCenter] postNotificationName:Chat_RoomNameChangeNotification object:result];
            }
            else {
                //改变群组聊天的头像
                [[NSNotificationCenter defaultCenter] postNotificationName:Chat_RoomHeadChangeNotification object:result];
            }
        }
        else if ([[result objectForKey:@"type"]isEqualToString:@"send_message"])
        {
            //发送消息
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_SendMessageBackNotification object:result];
        }
        else if ([[result objectForKey:@"type"]isEqualToString:@"push_message"])
        {
            //登录成功反馈包，之后服务器会推送未读消息(push_message)到客户端
            //如果是新消息就蜜汁震动一下。。振东，吸毒可震东cry😄
            
            if (SWNOTEmptyDictionary(result[@"result"])&&SWNOTEmptyArr(result[@"result"][@"list"])) {
                //如果消息不是重复的就振东，并发通知
                NSMutableArray *tempArr = [NSMutableArray new];
                NSMutableArray *tempConentArr = [NSMutableArray new];
//                for (NSDictionary *tempDic in result[@"result"][@"list"]) {
//                    NSString *message_id = SWToStr(tempDic[@"message_id"]);
//                    if (1) {
//                        //不包含
//                        if (![ChatDBHelper readMessageById:message_id]) {
//                            [ChatDBHelper saveMessage:tempDic];
//                            [shareChat.messgeIdArr addObject:message_id];
//                            [tempArr addObject:message_id];
//                            [tempConentArr addObject:tempDic];
//                            [[NSNotificationCenter defaultCenter]postNotificationName:Chat_RefreshChatUnreadCountNotification object:nil];
//                        }
//                    }
//                }
                if ([tempArr count]) {
                    //本地没有查询到，是新的数据,告诉服务器已读
                    NSDictionary *dic;
                    if (1) {
                        //dic = @{@"type":@"remove_push_message",@"message_ids":[tempArr componentsJoinedByString:@","],@"current_room_id":shareChat.chatingRoomId};
                    }else{
                        //不在当前房间才震动
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        dic = @{@"type":@"remove_push_message",@"message_ids":[tempArr componentsJoinedByString:@","]};
                    }
//                    for (NSDictionary *dic in tempConentArr) {
//                        ChatMessage *message = [ChatMessage mj_objectWithKeyValues:dic];
//                        //本地推送
//                        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//                            NSString *pushTitle = @"";
//                            if ([message.type isEqualToString:@"notify"]) {
//                                if ([message.notify_type isEqualToString:@"create_group_room"]) {
//                                    pushTitle = [NSString stringWithFormat:@"%@ 创建了群组",message.from_uname];
//                                }else if ([message.notify_type isEqualToString:@"add_group_member"]){
//                                    ChatUser *cUser;
//                                    if ([message.member_list count]) {
//                                        cUser = message.member_list[0];
//                                        pushTitle = [NSString stringWithFormat:@"%@ 加入了群组",cUser.uname];
//                                    }else{
//                                        pushTitle = @"房间动态";
//                                    }
//                                }else if ([message.notify_type isEqualToString:@"remove_group_member"]){
//                                    ChatUser *cUser;
//                                    if ([message.member_list count]) {
//                                        cUser = message.member_list[0];
//                                        pushTitle = [NSString stringWithFormat:@"%@ 被管理员移出了群组",cUser.uname];
//                                    }else{
//                                        pushTitle = @"房间动态";
//                                    }
//                                }else if ([message.notify_type isEqualToString:@"set_room"]){
//                                    if (message.room_info.group_type==1) {
//                                        pushTitle = [NSString stringWithFormat:@"%@ 修改群名称为 %@",message.from_uname,message.room_info.title];
//                                    }else{
//                                        pushTitle = [NSString stringWithFormat:@"%@ 修改了群头像",message.from_uname];
//                                    }
//                                }else if ([message.notify_type isEqualToString:@"quit_group_room"]){
//                                    pushTitle = [NSString stringWithFormat:@"%@ 退出了群组",message.quit_uname];
//                                }
//                            }
//                            else{
//                                pushTitle = [NSString stringWithFormat:@"%@: %@",message.from_uname,message.content];
//                            }
//                            [APService setLocalNotification:[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]] alertBody:pushTitle badge:[UIApplication sharedApplication].applicationIconBadgeNumber+1 alertAction:@"打开" identifierKey:SWUID userInfo:@{@"type":@"message",@"info":dic} soundName:nil];
//                        }
//                    }
                    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [_webSocket send:string];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_GetNewMessagesNotification object:result];
                }
            }
        }else if ([[result objectForKey:@"type"]isEqualToString:@"get_message_list"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_GetMessageListNotfication object:result];
        }
        else if ([[result objectForKey:@"type"]isEqualToString:@"clear_message"])
        {
            if (1)
            {
                NSLog(@"fuck");
                //楼上的兄弟消消气，我被你坑的时候只是cry默默的cyr😄
                NSLog(@"清空消息失败");
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Chat_DeleteChatRoomChatInfoNotification object:result];
            }
        }
    }
}


- (void)timerRun:(NSTimer *)timer
{
    long ntime = time(NULL);
    if (ntime-_ftime>15)
    {
       // shareChat.wsConnet = NO;//已断开连接
        NSLog(@"已经与服务器断开,正在重新连接 时间：%@",[NSDate date]);
        if (1) {
            [self reconnect];
            _reGetSWRespone = YES;//正在重连
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillResignActive:application];

//    [self NetWorkGetAd];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    [httpServer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [self startServer];
    
    
//    [self NetWorkGetAd];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (__allowRotation == YES) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}




@end
