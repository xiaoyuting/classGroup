//
//  SearchViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SearchViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "hooseClassify.h"
#import "ChooseTags.h"
#import "rootViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    NSString *hooseType = [[NSUserDefaults standardUserDefaults]objectForKey:@"HooseType"];
    switch ([hooseType integerValue]) {
        case 1:
            self.hoose.text = @"技术问答";
            break;
        case 2:
            self.hoose.text = @"技术分享";
            break;
        case 3:
            self.hoose.text = @"活动建议";
            break;
        default:
            break;
    }
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加右边的按钮
    UIButton *YButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 20, 60, 40)];
    [YButton setTitle:@"下一步" forState:UIControlStateNormal];
    YButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [YButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [YButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:YButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"描述问题";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];

    
//    UIButton *leftBtn = [UIButton buttonWithType:0];
//    leftBtn.frame = CGRectMake(0, 11, 45, 21);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"Arrow000.png"] forState:0];
//    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.titleText.delegate = self;
    self.titleText.hidden = YES;
    self.body.delegate = self;
    self.body.frame = CGRectMake(0,0, MainScreenWidth, MainScreenHeight / 2);
//    self.classify.hidden = YES;
    self.classify.backgroundColor = [UIColor redColor];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick)];
//    rightButton.tintColor = [UIColor colorWithRed:29.0/255.0 green:126.0/255.0 blue:183.0/255.0 alpha:1];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //添加图片的加号
//    self.addBtn = [UIButton buttonWithType:0];
//    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"+.png"] forState:0];
//    self.addBtn.frame = CGRectMake(8, 172, (self.bodyView.frame.size.width-8*6)/5, (self.bodyView.frame.size.width-8*6)/5);
//    [self.addBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bodyView addSubview:self.addBtn];
}
- (void)addImage:(UIButton *)sender
{
    UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerVC setAllowsEditing:YES];
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [self.imageArr addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];

    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(((self.bodyView.frame.size.width-8*6)/5+8)*(self.imageArr.count-1)+8, 172, (self.bodyView.frame.size.width-8*6)/5, (self.bodyView.frame.size.width-8*6)/5);
    [self.bodyView addSubview:btn];
    self.addBtn.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width+8, 172, ((self.bodyView.frame.size.width-8*6)/5), ((self.bodyView.frame.size.width-8*6)/5));
    [btn setBackgroundImage:[self.imageArr objectAtIndex:self.imageArr.count-1] forState:0];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)clickClassify:(id)sender {
}
-(void)aploadAttach:(NSString*)baseString
{
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:API_APP_api forKey:@"app"];
    [dic setObject:API_Mod_Attach forKey:@"mod"];
    [dic setObject:API_act_upload forKey:@"act"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"61" forKey:@"user_id"];
    [dic setValue:baseString forKey:@"attach_type"];
    
}
- (IBAction)choose:(id)sender
{
    hooseClassify *hse =[[hooseClassify alloc]init];
    [self.navigationController pushViewController:hse animated:YES];
}
-(void)nextClick
{
//    if (self.titleText.text.length <2 || self.titleText.text.length>20) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"标题不符合要求哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
//        return;
//    }
    if (self.body.text.length<3)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"内容不符合要求哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
        return;
    }
    
    ChooseTags  *chse = [[ChooseTags alloc]initWithQuizTitlt:self.titleText.text quizBody:self.body.text typeID:[[NSUserDefaults standardUserDefaults]objectForKey:@"HooseType"] quizIMG:self.imageArr];
    [self.navigationController pushViewController:chse animated:YES];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


//键盘消失
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;

}




@end
