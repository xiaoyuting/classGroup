//
//  AppDelegate.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "rootViewController.h"

#import "WXApi.h"

#import "SRWebSocket.h"
#import <PlayerSDK/PlayerSDK.h>
//#import <VodSDK/VodSDK.h>


@class HTTPServer;


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,SRWebSocketDelegate>
{
    UIWindow * window;
    HTTPServer *httpServer;
    SRWebSocket *_webSocket;
    BOOL _reGetSWRespone;//正在重新获得socket的回调,如果ping发现bool为yes代表需要去查看重发队列进行消息重发
    long _ftime;

    
}
@property (nonatomic, strong) GSPPlayerManager *playerManager;
@property (nonatomic, strong) GSPJoinParam *joinParam;

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL _allowRotation;

@property (strong,nonatomic)SRWebSocket *webSocket;

//@property (strong, nonatomic) VodPlayer *vodplayer;


+(AppDelegate *)delegate;

- (rootViewController *)rootVC;

@end

