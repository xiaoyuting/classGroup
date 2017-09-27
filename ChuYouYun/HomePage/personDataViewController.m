//
//  personDataViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕



#import "personDataViewController.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AFHTTPRequestOperationManager.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MyViewController.h"
#import "SYG.h"
#import "MBProgressHUD+Add.h"


@interface personDataViewController ()<UIActionSheetDelegate>
{
    NSString *headUrl;
    UIImage * image;
    CGRect rect;
    NSDictionary *userDic;
    NSDictionary *_users;
    BOOL isSex;
    MBProgressHUD *_MBProgressHUD;
    UIButton *BCButton;
}
@end

@implementation personDataViewController
-(id)initWithUserFace:(UIImage *)face
{
    self = [super init];
    if (self) {
        image = face;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterClass:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCome:) name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    

    
}
-(void)viewWillAppear:(BOOL)animated
{
    rect = [UIScreen mainScreen].applicationFrame;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"------%@",_allDict);

    [self addNav];
     NSString *plistPath = [Passport filePath];
    _users = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    isSex = NO;

    [_userName becomeFirstResponder];
    self.userName.text = _allDict[@"data"][@"uname"];
    NSLog(@"%@",_allDict[@"data"][@"uname"]);
    NSString *sex= _allDict[@"data"][@"sex"];
    [self.userSex setTitle:sex forState:0];
//    if ([sex   isEqual: @"1"]) {
//        [self.userSex setTitle:@"男" forState:0];
//    }else if ([sex isEqual:@"2"])
//    {
//        [self.userSex setTitle:@"女" forState:0];
//    }
    
    NSString *string;
    if ([_allDict[@"data"][@"intro"] isEqual:[NSNull null]]) {
        string = @"";
        self.userIdiograph.text = @"";
    }else {
         self.userIdiograph.text = _allDict[@"data"][@"intro"];
        string = self.userIdiograph.text;
    }
    
//    self.userIdiograph.text = string;
    self.textNumber.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)string.length];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];

    self.textNumber.textAlignment = NSTextAlignmentCenter;
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_allDict[@"data"][@"avatar_big"]] forState:0 placeholderImage:nil];
    
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius = 40;
    self.userSex.tag = 2;
    NSLog(@"%@",_users[@"intro"]);
    self.userIdiograph.delegate = self;
    self.userIdiograph.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
    self.userIdiograph.autocorrectionType = UITextAutocorrectionTypeYes;
    self.userIdiograph.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userIdiograph.keyboardType = UIKeyboardTypeDefault;
    self.userIdiograph.returnKeyType = UIReturnKeyDone;
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    [self.userName setInputAccessoryView:topView];
    [self.userIdiograph setInputAccessoryView:topView];
}

- (void)keyboardCome:(NSNotification *)Not {
    
    NSLog(@"你好评");
    
    //在这里改变frame
    if (iPhone6) {
         _userIdiograph.frame = CGRectMake(0, -60, MainScreenWidth, 90);
    }else {
        
    }
   

    
}

- (void)keyboardHide:(NSNotification *)Not {
    
    _userIdiograph.frame = CGRectMake(0, 30, MainScreenWidth, 80);
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加保存按钮
     BCButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
//    [BCButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [BCButton setTitle:@"保存" forState:UIControlStateNormal];
    [BCButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [BCButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:BCButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"个人资料";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)headImage:(id)sender
{
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
        //创建图片选取控制器
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];

 
        
    }else if (buttonIndex == 1){//相机拍照
        
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];

    }
}





-(void)sendUserData
{
    NSString  *sexType = nil;
    if (isSex == YES) {
        sexType = @"1";
    }else
    {
        sexType = @"2";
    }
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:self.userName.text forKey:@"uname"];
    [dic setObject:sexType forKey:@"sex"];
    [dic setObject:self.userIdiograph.text forKey:@"intro"];
    [manager sendUserData:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"资料上传成功" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)notify
{
    NSData *faceData=UIImagePNGRepresentation(image);
    NSMutableDictionary *face = [[NSMutableDictionary alloc]init];
    [face setValue:faceData forKey:@"userFace"];
    NSNotification *notification =[NSNotification notificationWithName:@"userFace" object:nil userInfo:face];
    NSLog(@"%@",face);
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)sendUserFace
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject: [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"] forKey:@"user_id"];
    [MBProgressHUD showMessag:@"正在上传中..." toView:self.view];
    
    [manager sendUserFace:dic constructing:^(id<AFMultipartFormData> formData) {
//    [[operationManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        NSData *dataImg=UIImageJPEGRepresentation(image, 1.0);
//        [[NSUserDefaults standardUserDefaults]setObject:image forKey:@"userface"];
        NSString *baseStr = [dataImg base64Encoding];
        NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
        [formData appendPartWithFileData:dataImg name:baseString fileName:[NSString stringWithFormat:@"%@.png",baseStr] mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:dataImg name:@"filedata" fileName:@"" mimeType:@"image/jpeg"];
        
        [MBProgressHUD showMessag:@"正在上传中..." toView:self.view];
     
       
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^^^%@",responseObject);
       
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
        
        NSString *msg = [responseObject objectForKey:@"msg"];
//        NSArray *data = [responseObject objectForKey:@"data"];
//        NSDictionary *facer = [data objectAtIndex:1];
//        NSString *small = [facer objectForKey:@"avatar_small"];
//        [[NSUserDefaults standardUserDefaults]setObject:small forKey:@"userface"];

        if (![msg isEqual:@"ok"]) {
            [MBProgressHUD showError:@"上传失败" toView:self.view];
        } else {
            [MBProgressHUD showError:@"上传成功" toView:self.view];
            self.headBtn.alpha = 1.0;
            [self.navigationController popViewControllerAnimated:YES];
            BCButton.enabled = YES;
            [self notify];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败vi");
//        [self notify];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [MBProgressHUD showError:@"上传失败" toView:self.view];
        self.headBtn.alpha = 1.0;
    }];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}


//- (void)sendUserFace {

//    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
//    [dic setObject: [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"] forKey:@"user_id"];
//
//    [manager sendUserFace:dic constructing:^(id<AFMultipartFormData> formData) {
//        
//        NSData *dataImg=UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSLog(@"%@",responseObject[@"msg"]);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//
    
    
//}

- (IBAction)sexClick:(id)sender
{
    isSex = !isSex;
    UIButton *btn = (UIButton *)sender;
    if (isSex == YES) {
        [btn setTitle:@"男" forState:0];
    }else
    {
        [btn setTitle:@"女" forState:0];
    }
}

-(void)rightBtnClick
{
    NSString *imgUrl = [NSString stringWithFormat:@"%@",_allDict[@"data"][@"avatar_big"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imgUrl forKey:@"GLAcon"];
    NSString *unname = [NSString stringWithFormat:@"%@",_allDict[@"data"][@"uname"]];
    [defaults setObject:unname forKey:@"uname"];
    
    BCButton.enabled = NO;

    self.headBtn.alpha = 0.1;
    
    if ([_headBtn imageForState:0] == image ) {
         [self sendUserData];
    } else {
        [self sendUserFace];
        [self sendUserData];
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [_headBtn setBackgroundImage:image forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)afterClass:(NSNotification *)noti
{
    NSLog(@"noti______%@",noti);
    self.userIdiograph =(UITextView *)noti.object;
    NSLog(@"textview.text--------%@",self.userIdiograph.text);

    if (self.userIdiograph.text.length >= 50) {
        [MBProgressHUD showError:@"输入文字长度不大于50字" toView:self.view];
        self.userIdiograph.text = [self.userIdiograph.text substringToIndex:50];
    }
    NSString *string =[NSString stringWithFormat:@"%lu/50",(unsigned long)self.userIdiograph.text.length];
    self.textNumber.text = string;
}

//关闭键盘
-(void) dismissKeyBoard{
    [self.userIdiograph resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.userSex resignFirstResponder];
}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


@end
