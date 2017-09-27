//
//  UserLoginViewController.m
//  Right
//
//  Created by ZhiYiForMac on 15/1/20.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "UserLoginViewController.h"
#import "blumViewController.h"
#import "rootViewController.h"

#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "BaseClass.h"
#import "Data.h"
#import "ZhiyiHTTPRequest.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "findOfEmailViewController.h"
#import "Passport.h"
#import "EaseMob.h"
#import "MyViewController.h"

@interface UserLoginViewController ()
{
    BaseClass *base;
}
@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  =[UIColor blackColor];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_loginBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 0 });
    [_loginBtn.layer setBorderColor:colorref];//边框颜色
}
-(void)loginrequest
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.userName.text forKey:@"uname"];
    [dic setValue: self.passWord.text forKey:@"upwd"];
    [manager userLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            
            rootViewController *blum = [[rootViewController alloc]init];
            self.view.window.rootViewController = blum;
            
//            MyViewController * more = [[MyViewController alloc]init];
//            self.view.window.rootViewController = more;
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults]setObject:self.userName.text forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults]setObject:self.passWord.text forKey:@"upwd"];
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)saveUserData
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToHomePage:(id)sender {
    if ([_userName.text isEqual:@""] || _passWord.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录信息未完善" message:@"返回修改" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self loginrequest];
}
- (IBAction)registerClick:(id)sender
{
    RegisterViewController *rVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Register"];
    [self presentViewController:rVc animated:YES completion:nil];
}
- (IBAction)findPassword:(id)sender
{
    findOfEmailViewController *fVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"findE"];
    [self presentViewController:fVc animated:YES completion:nil];
}

- (IBAction)sinaClick:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self loginWithSNSAccount:snsAccount loginType:@"sina"];
        }});

}
- (IBAction)tencenClick:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self loginWithSNSAccount:snsAccount loginType:@"QQ"];
        }});

}
- (IBAction)peopleClick:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self loginWithSNSAccount:snsAccount loginType:@"wx"];
        }});
}
- (void)loginWithSNSAccount:(UMSocialAccountEntity *)snsAccount loginType:(NSString *)type
{
    ZhiyiHTTPRequest * manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    /*
     if ([snsAccount.platformName isEqualToString:UMShareToSina]) {
     //新浪平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToTencent]) {
     //腾讯微博平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToQQ] || [snsAccount.platformName isEqualToString:UMShareToQzone]) {
     //qq/空间平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToRenren]) {
     //人人平台的特殊处理
     }
     */
    NSLog(@">>>%@",snsAccount);
    [dic setValue:snsAccount.accessToken forKey:@"app_token"];
    [dic setValue:type forKey:@"app_login_type"];
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"loginType"];
    [manager userLoginOfThirdParty:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8001" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
                if (!error) {
                    // 设置自动登录
                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                }
            } onQueue:nil];
            rootViewController *blum = [[rootViewController alloc]init];
            self.view.window.rootViewController = blum;
            
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
