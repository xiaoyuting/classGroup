//
//  PersonInfoViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 17/1/24.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"



@interface PersonInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSString *headUrl;
    UIImage * image;
    CGRect rect;
    NSDictionary *userDic;
    NSDictionary *_users;
    BOOL isSex;
    BOOL isUp;//视图是否上滑
    UIButton *BCButton;
}

@property (strong ,nonatomic)UIView *headerView;
@property (strong ,nonatomic)UITextField *nameField;
@property (strong ,nonatomic)UIButton *sexButton;
@property (strong ,nonatomic)UITextView *userInfo;


@end

@implementation PersonInfoViewController

-(id)initWithUserFace:(UIImage *)face
{
    self = [super init];
    if (self) {
        image = face;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotfiton];
    [self interFace];
    [self addNav];
    [self addScrollView];
    [self addHeaderImage];
    [self addPersonInfo];
    [self addTopView];
    [self information];

}

#pragma mark --- 初始化

- (void)addNotfiton {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCome:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)interFace {
    isSex = NO;
    isUp = YES;
    NSLog(@"%@",_allDict);
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加保存按钮
    BCButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [BCButton setTitle:@"保存" forState:UIControlStateNormal];
    [BCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BCButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:BCButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"个人资料";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---- View (界面)
- (void)addScrollView {
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    
}

- (void)addHeaderImage {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollview addSubview:headerView];
    _headerView = headerView;
    
    _headerImageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, 40, 80, 80)];
    _headerImageButton.layer.cornerRadius = 40;
    _headerImageButton.layer.masksToBounds = YES;
    [_headerImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_allDict[@"data"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    [_headerImageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_headerImageButton];
    
}



- (void)addPersonInfo {
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), MainScreenWidth, 300)];
    infoView.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:infoView];
    
    
    NSArray *titleArray = @[@"昵称",@"性别",@"个人资料"];
    for (int i = 0 ; i < titleArray.count; i ++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 60 * i, 80, 60)];
        title.text = titleArray[i];
        title.textColor = [UIColor grayColor];
        [infoView addSubview:title];
        
        if (i == 0) {//名字
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0, MainScreenWidth - 60, 60)];
            _nameField.text = _allDict[@"data"][@"uname"];
            if (_nameField.text.length > 15) {
                _nameField.text = [_nameField.text substringToIndex:15];
            }
            _nameField.textColor = [UIColor blackColor];
            _nameField.delegate = self;
            [infoView addSubview:_nameField];
            if (iPhone5o5Co5S) {
                if (_nameField.text.length > 13) {
                    _nameField.text = [_nameField.text substringToIndex:13];
                }
            } else if (iPhone6) {
                if (_nameField.text.length > 16) {
                    _nameField.text = [_nameField.text substringToIndex:16];
                }
            } else if (iPhone6Plus) {
                if (_nameField.text.length > 18) {
                    _nameField.text = [_nameField.text substringToIndex:18];
                }
            }
        } else if (i == 1) {//性别
            _sexButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 60, MainScreenWidth, 60)];
            NSString *sex= _allDict[@"data"][@"sex"];
            [_sexButton setTitle:sex forState:UIControlStateNormal];
            [_sexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _sexButton.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, MainScreenWidth - 30);
            [infoView addSubview:_sexButton];
            [_sexButton addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (i == 2) {//个人资料
            _userInfo = [[UITextView alloc] initWithFrame:CGRectMake(10, 190, MainScreenWidth, 60)];
            _userInfo.font = Font(16);
            if ([_allDict[@"data"][@"intro"] isEqual:[NSNull null]]) {
                _userInfo.text = @"";
            }else {
                _userInfo.text = _allDict[@"data"][@"intro"];
            }
            [infoView addSubview:_userInfo];
            
            //添加字数
            _textNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, MainScreenWidth - 20, 30)];
            [infoView addSubview:_textNumber];
            _textNumber.textAlignment = NSTextAlignmentRight;
            
            
            NSString *string;
            if ([_allDict[@"data"][@"intro"] isEqual:[NSNull null]]) {
                string = @"";
            }else {
                string = _userInfo.text;
            }
            self.textNumber.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)string.length];

        }
        
    }
    
    
}

- (void)addTopView {
    _userInfo.delegate = self;
    _userInfo.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
    _userInfo.autocorrectionType = UITextAutocorrectionTypeYes;
    _userInfo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userInfo.keyboardType = UIKeyboardTypeDefault;
    _userInfo.returnKeyType = UIReturnKeyDone;
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    [_nameField setInputAccessoryView:topView];
    [_userInfo setInputAccessoryView:topView];

    
}

#pragma mark --- 相册相机

- (void)headerImageButtonClick:(UIButton *)button {
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [_headerImageButton setBackgroundImage:image forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 事件点击
- (void)sexButtonClick:(UIButton *)button {
    isSex = !isSex;
    if (isSex == YES) {
        [_sexButton setTitle:@"男" forState:UIControlStateNormal];
    }else
    {
        [_sexButton setTitle:@"女" forState:UIControlStateNormal];
    }
}

-(void)rightBtnClick
{
    BCButton.enabled = NO;
    
    if ([_headerImageButton imageForState:0] == image ) {
        [self sendUserData];
    } else {
        [self sendUserFace];
        [self sendUserData];
    }
}


#pragma mark --- 通知监听

//昵称
- (void)textFieldChange:(NSNotification *)Not {
    isUp = NO;
    
    if (_nameField.text.length > 15) {
        [MBProgressHUD showError:@"昵称不能过长" toView:self.view];
        _nameField.text = [_nameField.text substringToIndex:15];
        return;
    }
}

- (void)textViewTextChange:(NSNotification *)Not {
    
    if (_userInfo.text.length >= 50) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入文字长度不大于50字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        [MBProgressHUD showError:@"输入文字长度不大于50字" toView:self.view];
        _userInfo.text = [_userInfo.text substringToIndex:50];
        [_scrollview setContentOffset:CGPointMake(0,200) animated:YES];
        
    }
    NSString *string =[NSString stringWithFormat:@"%lu/50",(unsigned long)_userInfo.text.length];
    self.textNumber.text = string;
    
}



//键盘弹起
- (void)keyboardCome:(NSNotification *)Not {

//    NSLog(@"%@",isUp);
    NSLog(@"%@",Not.userInfo);
    if (isUp == YES) {
        [_scrollview setContentOffset:CGPointMake(0,200) animated:YES];
        isUp = YES;
    } else {
        isUp = NO;
        [_scrollview setContentOffset:CGPointMake(0,0) animated:YES];
    }

}

//键盘下去
- (void)keyboardHide:(NSNotification *)Not {
    
    [_scrollview setContentOffset:CGPointMake(0,0) animated:YES];
    isUp = !isUp;
}

#pragma mark --- 网络请求
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
    [dic setObject:_nameField.text forKey:@"uname"];
    [dic setObject:sexType forKey:@"sex"];
    [dic setObject:_userInfo.text forKey:@"intro"];
    [manager sendUserData:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {//成功
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            [self backPressed];
        } else {
            [MBProgressHUD showError:@"保存失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showError:@"保存失败" toView:self.view];
    }];
}


-(void)sendUserFace
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject: [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"] forKey:@"user_id"];
    [manager sendUserFace:dic constructing:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(image, 1.0);
        NSString *baseStr = [dataImg base64Encoding];
        NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
        [formData appendPartWithFileData:dataImg name:baseString fileName:[NSString stringWithFormat:@"%@.png",baseStr] mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD showError:@"上传成功" toView:self.view];
    }];
    
}

#pragma mark --- 滚动视图
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}

-(void)textFieldDidBeginEditing:(UITextField*)textField {
    isUp = NO;

}


//关闭键盘
-(void) dismissKeyBoard{
    [_userInfo resignFirstResponder];
    [_nameField resignFirstResponder];
    [self.userSex resignFirstResponder];
}


- (void)information {//获取到用户的资料
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"] forKey:@"user_id"];
    
    [manager userShow:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _allInformation = responseObject;
        _allDict = responseObject;
        [self addScrollView];
        [self addHeaderImage];
        [self addPersonInfo];
        [self addTopView];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
}



@end
