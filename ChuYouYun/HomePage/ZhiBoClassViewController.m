//
//  ZhiBoClassViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import "ZhiBoClassCell.h"
#import "BigWindCar.h"

#import "DLViewController.h"
#import "HDZBLiveViewController.h"
#import "PlayBackViewController.h"
#import "ZhiBoWebViewController.h"
#import <VodSDK/VodSDK.h>

#import <EplayerPluginFramework/EPlayerPluginViewController.h>


//。CC 直播
#import "CCSDK/CCLiveUtil.h"
#import "CCSDK/RequestData.h"
#import "CCSDK/RequestDataPlayBack.h"
//#import "CCHHPlayViewController.h"
//#import "CCHHPlayBackViewController.h"

#import "PlayForPCVC.h"
#import "PlayBackVC.h"


#import <QuartzCore/QuartzCore.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "QRCodeReaderDelegate.h"


@interface ZhiBoClassViewController ()<UITableViewDataSource,UITableViewDelegate,VodDownLoadDelegate,QRCodeReaderDelegate,RequestDataDelegate,RequestDataPlayBackDelegate>
{
    BOOL islivePlay;
}
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *HDtitle;
@property (strong ,nonatomic)NSString *HDnickName;
@property (strong ,nonatomic)NSString *HDwatchPassword;
@property (strong ,nonatomic)NSString *HDroomNumber;

@property (assign ,nonatomic)BOOL isBuyZhiBo;
@property (strong ,nonatomic)NSDictionary *playLiveBackDic;
@property (strong ,nonatomic) VodDownLoader *voddownloader;
@property (strong ,nonatomic)PlayBackViewController *playBackVc;


@property (assign, nonatomic) NSInteger                 liveType;
@property (strong ,nonatomic) NSDictionary *CCDict;

@end

@implementation ZhiBoClassViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWork];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _isBuyZhiBo = NO;
    
    
    _playBackVc = [[PlayBackViewController alloc] init];
    
    if (!_voddownloader) {
        _voddownloader = [[VodDownLoader alloc]init];
    }
    _voddownloader = [[VodDownLoader alloc]init];
    _voddownloader.delegate = self;
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300) style:UITableViewStyleGrouped];
    if (iPhone5o5Co5S) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300);
    } else if (iPhone6) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300 - 20);
    } else if (iPhone6Plus) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300 - 40);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
}

#pragma mark ---- UITableVieDataSoruce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"LiveDetailOneCell";
    //自定义cell类
    ZhiBoClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ZhiBoClassCell alloc] initWithReuseIdentifier:CellID];
    }
    [cell.numberButton setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1] forState:UIControlStateNormal];
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    NSString *liveStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note"]];
//    if ([liveStr isEqualToString:@"已结束"]) {
//        [MBProgressHUD showSuccess:@"直播已结束" toView:_tableView];
//        return;
//    }
    // 这里应该判断是否已经登录
    if (UserOathToken == nil) {
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else{
        
        if (_isBuyZhiBo == YES) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            _HDnickName = [defaults objectForKey:@"WDC"];
            NSLog(@"%@",_dataArray[indexPath.row]);
            //参数
            _HDtitle = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"subject"];
            NSString *ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
            NSString *secitonID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"section_id"];
            
            [self NetWorkGetUrl:ID WithSecitionID:secitonID];
            
        }else{
            [MBProgressHUD showError:@"您尚未购买，请购买后观看" toView:_tableView];
        }
    }

    
}

#pragma mark --- 网络请求

- (void)netWork
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //        return;
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_ID forKey:@"live_id"];
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        _dataArray = responseObject[@"data"][@"sections"];
        NSString *buyStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_buy"]];
        if ([buyStr integerValue] == 1) {
            _isBuyZhiBo = YES;
        } else {
            _isBuyZhiBo = NO;
        }
        if (_dataArray.count == 0) {
            if (_imageView.subviews.count == 0) {
                //添加空白提示
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
                imageView.image = Image(@"更改背景图片.png");
                imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
                if (iPhone6) {
                    imageView.center = CGPointMake(MainScreenWidth / 2 , 170);
                } else if (iPhone6Plus) {
                    imageView.center = CGPointMake(MainScreenWidth / 2 , 200);
                } else if (iPhone5o5Co5S) {
                    imageView.frame = CGRectMake(0, 100, 100, 100);
                    imageView.center = CGPointMake(MainScreenWidth / 2 , 140);
                }
                [self.view addSubview:imageView];
            }
        } else {
            _imageView.hidden = YES;
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
}

#pragma mark --- 直播链接
- (void)NetWorkGetUrl:(NSString *)ID WithSecitionID:(NSString *)secitonID {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:ID forKey:@"live_id"];
    [dic setValue:secitonID forKey:@"section_id"];
    
    [manager BigWinCar_getLiveUrl:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"type"] integerValue] == 1) {//展示互动
                
                NSDictionary *playBackDic = responseObject[@"data"][@"livePlayback"];
                if ( playBackDic == nil ||[responseObject[@"data"][@"livePlayback"] isEqual:[NSNull null]] ) {//直播
                    _HDwatchPassword = responseObject[@"data"][@"body"][@"join_pwd"];
                    _HDroomNumber = responseObject[@"data"][@"body"][@"number"];
                    HDZBLiveViewController *hdzb = [[HDZBLiveViewController alloc]init];
                    [hdzb initwithTitle:_HDtitle nickName: _HDnickName watchPassword:_HDwatchPassword roomNumber:_HDroomNumber];
                    hdzb.account = responseObject[@"data"][@"body"][@"account"];
                    hdzb.domain = responseObject[@"data"][@"body"][@"domain"];
                    [self.navigationController pushViewController:hdzb animated:YES];
                } else {//在线回放
                    _playLiveBackDic = responseObject[@"data"][@"livePlayback"];
                    NSLog(@"%@",_playLiveBackDic);
                    
                    NSString *string = _playLiveBackDic[@"url"];
                    NSRange startRange = [string rangeOfString:@"http://"];
                    NSRange endRange = [string rangeOfString:@"/training"];
                    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                    NSString *result = [string substringWithRange:range];
                    NSLog(@"%@",result);
                    
                    [_voddownloader addItem:result number:_playLiveBackDic[@"number"] loginName:_HDnickName vodPassword:_playLiveBackDic[@"token"] loginPassword:_playLiveBackDic[@"number"] downFlag:0 serType:@"training" oldVersion:NO kToken:nil customUserID:0];

                }
                

            } else if ([responseObject[@"data"][@"type"] integerValue] == 2){//光辉直播
                    EPlayerData *playerData =[[EPlayerData alloc] init];
                    playerData.liveClassroomId = ID;
                    playerData.customer = @"seition";
                    playerData.loginType = EPlayerLoginTypeNone;
                    EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
                    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
                    [self.navigationController pushViewController:controller animated:YES];
            } else if ([responseObject[@"data"][@"type"] integerValue] == 4) {//CC 直播
                
                NSLog(@"%@",responseObject[@"data"]);
                if (responseObject[@"data"][@"livePlayback"] == nil) {//直播
                    [self useCCLive:responseObject[@"data"][@"body"]];
                } else {//回放
                    
                }
            }
            
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}




#pragma mark - VodDownLoadDelegate (展示互动的回放)
//添加item的回调方法
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item
{
    islivePlay = YES;
    NSLog(@"状态resultType----%d",resultType);
    if (resultType == RESULT_SUCCESS) {
        
        
        //        vodId = item.strDownloadID;
        if (islivePlay) {
            [_playBackVc setItem:item];
            [_playBackVc setIsLivePlay:YES];
            [self.navigationController pushViewController:_playBackVc animated:YES];
        } else {
//            [_downloadViewController setDomain:_domain.text];
//            [_downloadViewController setNumber:_number.text];
//            [_downloadViewController setVodPassword:_vodPassword.text];
//            [_downloadViewController setSeviceType:_serviceType.text];
//            
//            [self.navigationController pushViewController:_downloadViewController animated:YES];
        }
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else if (resultType == RESULT_ROOM_NUMBER_UNEXIST){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"点播间不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAILED_NET_REQUIRED){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"网络请求失败" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_LOGIN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"用户名或密码错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_NOT_EXSITE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"该点播的编号的点播不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_INVALID_ADDRESS){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"无效地址" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_UNSURPORT_MOBILE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"不支持移动设备" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_TOKEN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"口令错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark ---- CC 直播

- (void)useCCLive:(NSDictionary *)dict {//CC 直播
    NSLog(@"----%@",dict);
    _CCDict = dict;
    NSString *strUserId = [dict stringValueForKey:@"userid"];
    NSString *strRoomId = [dict stringValueForKey:@"roomid"];
    NSString *strViewName = @"用户";
    NSString *strToken = [dict stringValueForKey:@"join_pwd"];
    
    BOOL haveEmpty = false;
    
    
    if (strUserId == nil || strUserId.length == 0) {
        haveEmpty = true;
    }
    if (strRoomId == nil || strRoomId.length == 0) {
        haveEmpty = true;
    }
    if (strViewName == nil || strViewName.length == 0) {
        haveEmpty = true;
    }
    if (strToken == nil || strToken.length == 0) {
        haveEmpty = true;
    }
    
    if (haveEmpty == false) {
    }
    
    if (haveEmpty == false) {
        
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = returnButtonItem;
        
        if (self.liveType == 0) {
//            RequestData *requestData = [[RequestData alloc] initOnlyLoginWithUserId:strUserId RoomId:strRoomId ViewerName:strViewName ViewerToken:strToken security:YES];
//            requestData.delegate = self;
            
        } else if(self.liveType == 1) {
//            RequestDataPlayBack *requestDataPlayBack = [[RequestDataPlayBack alloc] initOnlyLoginWithUserId:strUserId RoomId:strRoomId Liveid:strLevelId Viewername:strViewName Viewertoken:strToken security:YES];
//            requestDataPlayBack.delegate = self;
        }
        
        PlayParameter *parameter = [[PlayParameter alloc] init];
        parameter.userId = strUserId;
        parameter.roomId = strRoomId;
        parameter.viewerName = strViewName;
        parameter.token = strToken;
        parameter.security = YES;
        parameter.viewercustomua = @"viewercustomua";
        RequestData *requestData = [[RequestData alloc] initLoginWithParameter:parameter];
        requestData.delegate = self;
        
    }
    
    
}



#pragma mark --- CC 直播代理方法

#pragma mark - CCPushDelegate
//@optional
/**
 *	@brief	请求成功
 */
-(void)loginSucceedPlay {
    NSLog(@"%@",_CCDict);
    
    NSString *strUserId = [_CCDict stringValueForKey:@"userid"];
    NSString *strRoomId = [_CCDict stringValueForKey:@"roomid"];
    NSString *strViewName = _HDnickName;
    NSString *strToken = [_CCDict stringValueForKey:@"join_pwd"];
    
    PlayForPCVC *playVc = [[PlayForPCVC alloc] initWithRoomId:strRoomId WithUserId:strUserId WithViewerName:strViewName WithToken:strToken];
    [self presentViewController:playVc animated:YES completion:nil];
}

/**
 *	@brief	登录请求失败
 */
-(void)loginFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    
    [MBProgressHUD showError:message toView:self.view];
}


#pragma mark -- CC 回放
- (void)CCPlayBack {
    
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = @"";
    parameter.roomId = @"";
    parameter.liveid = @"";
    parameter.viewerName = @"";
    parameter.token = @"";
    parameter.security = YES;
    RequestDataPlayBack *requestDataPlayBack = [[RequestDataPlayBack alloc] initLoginWithParameter:parameter];
    requestDataPlayBack.delegate = self;
}

#pragma mark -- CC回放的代理方法
//@optional
/**
 *	@brief	请求成功
 */
-(void)loginSucceedPlayBack {
//    SaveToUserDefaults(PLAYBACK_USERID,_textFieldUserId.text);
//    SaveToUserDefaults(PLAYBACK_ROOMID,_textFieldRoomId.text);
//    SaveToUserDefaults(PLAYBACK_LIVEID,_textFieldLiveId.text);
//    SaveToUserDefaults(PLAYBACK_USERNAME,_textFieldUserName.text);
//    SaveToUserDefaults(PLAYBACK_PASSWORD,_textFieldUserPassword.text);
    
//    [_loadingView removeFromSuperview];
//    _loadingView = nil;
    PlayBackVC *playBackVC = [[PlayBackVC alloc] initWithRoomId:@"" WithUserId:@"" WithViewerName:@"" WithToken:@""];
    [self presentViewController:playBackVC animated:YES completion:nil];
}

/**
 *	@brief	登录请求失败
 */
//-(void)loginFailed:(NSError *)error reason:(NSString *)reason {
//    NSString *message = nil;
//    if (reason == nil) {
//        message = [error localizedDescription];
//    } else {
//        message = reason;
//    }
//    [_loadingView removeFromSuperview];
//    _loadingView = nil;
//    InformationShowView *informationView = [[InformationShowView alloc] initWithLabel:message];
//    [self.view addSubview:informationView];
//    [informationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    
//    [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [informationView removeFromSuperview];
//    }];
//}




@end
