
#import <UIKit/UIKit.h>

@protocol EPlayerPluginViewDelegate;

@interface EPlayerPluginParma : NSObject

/**
 * 显示DEBUG日志
 */
+ (void)setLogEnabled:(BOOL)value;

/**
 * 使用测试服务器
 */
+ (void)useTest;

/**
 * TODO 设置SDK 支持的设备
 */
+ (void)setSupportInterfaceIdiom:(UIUserInterfaceIdiom) userInterfaceIdiom;

@end

//-----------------------------
//-----------------------------
//---------新加进入房间参数-----------
//-----------------------------

//帐号登录方式
typedef NS_ENUM(NSInteger, EPlayerLoginType){
    EPlayerLoginTypeNone            =0,     //免费课
    EPlayerLoginTypeUserPwd         =1,     //帐号密码方式，仅限内部使用
    EPlayerLoginTypeAuthReverse     =2,     //反向验证方式，参考协议文档，对应参数exStr
    EPlayerLoginTypeAuthForward     =3      //正向验证码方式，参考协议文档，对应参数p
};

//课堂观看模式：
typedef NS_ENUM(NSInteger, EPlayerPlayModelType){
    EPlayerPlayModelTypeLive           =0,     //直播
    EPlayerPlayModelTypePlayback        =1,     //回看
};

@interface EPlayerData : NSObject

@property (nonatomic,strong) NSString *liveClassroomId;  //直播房间
@property (nonatomic,strong) NSString *customer;         //接入客户编号


@property (nonatomic,assign) EPlayerLoginType loginType; //登录方式


@property (nonatomic,strong) NSString *user;             //帐号
@property (nonatomic,strong) NSString *pwd;              //密码

@property (nonatomic,strong) NSString *validateStr;      //验证字符串，

@property (nonatomic,assign) EPlayerPlayModelType playModel;  //播放模式

@property (nonatomic,assign) NSString *playbackid;       //房间中的某一次回看，默认为nil表示最新的回看

@end


@interface EPlayerPluginViewController : UIViewController

/**
 * * * 代理协议,
 *
 **/
@property (nonatomic,weak) id<EPlayerPluginViewDelegate> delegate NS_DEPRECATED_IOS(2_0, 5_0, "-----Delete------");

/**
 * * * 使用系统内账号密码方式登陆
 *
 * roomId:直播房间编号
 * customer:客户类型
 * user:账号
 * pwd:密码
 **/

-(id)initWithClassroomId:(NSString *)roomId customer:(NSString *)customer user:(NSString *)user pwd:(NSString *)pwd NS_DEPRECATED_IOS(2_0, 5_0, "Use .initPlayer:   and loginType = EPlayerLoginTypeUserPwd");


/**
 * * * 使用第三方鉴权token方式登陆
 *
 * roomId:直播房间编号
 * customer:客户类型
 * exStr:第三方生成的exStr
 **/

-(id)initWithClassroomId:(NSString *)roomId customer:(NSString *)customer exStr:(NSString *)exStr NS_DEPRECATED_IOS(2_0, 5_0, "Use .initPlayer:    and loginType = EPlayerLoginTypeAuthReverse");

/**
 *  切换到回看
 *
 *  @param playid   为回看编号，同一个房间可以拥有多个回看编号，默认为nil
 *
 */
- (void)switchToPlaybackModel:(NSString *)playid NS_DEPRECATED_IOS(2_0, 5_0, "Use .initPlayer:");

/**
 * * * 调用E课堂界面
 *
 * playerData:播放信息数据
 **/
- (id)initPlayer:(EPlayerData *)playerData NS_AVAILABLE_IOS(5_0);



@end

/**
 * * * 代理协议
 *
 **/
@protocol EPlayerPluginViewDelegate <NSObject>

@optional
/**
 * * * 退出界面回调
 *
 * SDK 已经负责pop到进入时的UINavgationController
 *
 * picker:  使用的controller
 * info:    返回的数据，默认为NULL
 **/
- (void)playerPluginViewController:(EPlayerPluginViewController *)controller didFinishWithInfo:(NSDictionary *)info;


@end