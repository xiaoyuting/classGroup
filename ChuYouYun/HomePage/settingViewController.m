//
//  settingViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width



#import "settingViewController.h"
#import "UIButton+WebCache.h"
#import "personDataViewController.h"
#import "alterPWViewController.h"
#import "myRemainingViewController.h"
#import "MyBankViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "Passport.h"
#import "EaseMob.h"
#import "ZhiyiHTTPRequest.h"
#import "YEViewController.h"
#import "DLViewController.h"
#import "RecuperationViewController.h"
#import "SYG.h"

#import "PersonInfoViewController.h"

#import "AboutUsViewController.h"


@interface settingViewController ()

{
    NSArray *textArr;
    NSArray *imageArr;
    NSString *_firstName;
    NSString *_imagurl;
}
@property (strong ,nonatomic)UIButton *btn;
@property (strong ,nonatomic)UILabel  *lbl;
@property (strong ,nonatomic)UILabel *sizeLabel;
@property (assign ,nonatomic)NSInteger totaiZise;
@end

@implementation settingViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _firstName = [defaults objectForKey:@"uname"];
    _imagurl = [defaults objectForKey:@"GLAcon"];
    NSLog(@"===%@",_firstName);
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self information];
    });
    if (_tableView) {
        [_tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self information];
}
-(id)initWithUserFace:(UIImage *)face userName:(NSString *)name
{
    self =[super init];
    if (self) {
        self.face = face;
        self.myName = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNav];
    NSLog(@"%@",_allDic);
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    textArr = [[NSArray alloc]initWithObjects:@"我的余额",@"我的银行卡" ,nil];
    imageArr = [NSArray arrayWithObjects:@"Shape 189.png",@"card.png", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFace:) name:@"userFace" object:nil];
    [self information];
    //    [self fileSize];
    
    //计算本地缓存
    NSString *onePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSInteger oneSize = [self fileSizeWithPath:onePath];
    
    NSString *twoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSInteger twoSize = [self fileSizeWithPath:twoPath];
    
    NSLog(@"%ld  %ld",oneSize,twoSize);
    _totaiZise = oneSize + twoSize;
//    _totaiZise = oneSize;
    NSLog(@"%ld",_totaiZise);
    
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"个人设置";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)userFace:(NSNotification *)info
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:5];
    UIImage *image = [UIImage imageWithData:[info.userInfo objectForKey:@"userFace"]];
    self.face = image;
    [btn setBackgroundImage:image forState:0];
    //    [btn sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"small"] forState:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else if (section == 0) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        } else if (indexPath.row == 1) {
            return 50;
        }
        return 80;
    }
    if (indexPath.section == 3) {
        return 60;
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    if (section == 3) {//退出账号
        return 30;
    }
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.sectionHeaderHeight, tableView.frame.size.width)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _btn = [UIButton buttonWithType:0];
            _btn.tag = 5;
            _btn.frame = CGRectMake(10, 15, 50, 50);
            _btn.clipsToBounds = YES;
            [_btn addTarget:self action:@selector(btnClick) forControlEvents:0];
            
            [_btn.layer setCornerRadius:25];
            
            _lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 200, 21)];
            NSString *imgUrl = [NSString stringWithFormat:@"%@",_allDic[@"data"][@"avatar_middle"]];
            NSLog(@"%@",_allDic[@"data"][@"uname"]);
            _lbl.text = _allDic[@"data"][@"uname"];
            [_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:0 placeholderImage:nil];
            [cell addSubview:_btn];
            [cell addSubview:_lbl];
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIButton *btn = [UIButton buttonWithType:0];
                btn.frame = CGRectMake(17, 10, 30, 25);
                btn.clipsToBounds = YES;
                [btn setImage:[UIImage imageNamed:[imageArr objectAtIndex:0]] forState:0];
                
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(64, 14, 100, 21)];
                lbl.text = [textArr objectAtIndex:0];
                
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 70, 14, 60, 21)];
                if (indexPath.row == 1) {
                    NSString *learnMoney = [NSString stringWithFormat:@"%d元",99999];
                    numberLbl.text = learnMoney;
                }
                numberLbl.text = [NSString stringWithFormat:@"%@积分",_score];
                numberLbl.textAlignment = NSTextAlignmentRight;
                numberLbl.textColor = [UIColor grayColor];
                
                [cell addSubview:btn];
                [cell addSubview:lbl];
                [cell addSubview:numberLbl];
            }
            return cell;
        } else {
            return nil;
        }
        
    } else if(indexPath.section == 1) {
        static NSString *identifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSArray *array= @[@"修改密码",@"允许非wifi环境下观看和下载"];
        if (!cell) {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30, 21)];
                numberLbl.text = array[0];
                [cell addSubview:numberLbl];
            }else{
                //初始化开关控件，CGRectMake(x坐标，y坐标，宽，高)
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 10, 150, 40)];
                //设置开关为YES状态
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *passWord = [ user objectForKey:@"netRook"];
                if ([passWord isEqualToString:@"1"]) {
                    [mySwitch setOn:YES];
//
                }else{
                    
                    [mySwitch setOn:NO];
                }
                //为控件添加事件
                [mySwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
                //向视图中添加该控件
                
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30,21)];
                numberLbl.text = array[1];
                [cell addSubview:numberLbl];
                [cell addSubview:mySwitch];
                
            }
        }
        return cell;
    }else if (indexPath.section == 2) {
        NSArray *array= @[@"意见反馈",@"清除缓存",@"关于我们"];
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if (indexPath.row==0) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30, 21)];
                numberLbl.text = array[0];
                [cell addSubview:numberLbl];
                
            }else if  (indexPath.row == 1){
                
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, 125, 21)];
                numberLbl.text = array[1];
                [cell addSubview:numberLbl];
                
                //添加缓存大小的按钮
                
                _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 0, 100, 40)];
                _sizeLabel.text = [NSString stringWithFormat:@"%ldK",_totaiZise / 1000];
                _sizeLabel.textAlignment = NSTextAlignmentRight;
                [cell addSubview:_sizeLabel];
            } else if (indexPath.row == 2) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30, 21)];
                numberLbl.text = array[2];
                numberLbl.textColor = [UIColor redColor];
                [cell addSubview:numberLbl];
            }
            
        }
        return cell;
        
    } else if (indexPath.section == 3) {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2+20, (60-21)/2, 100, 21)];
            numberLbl.textColor = [UIColor whiteColor];
            numberLbl.text = @"退出账号";
            [cell addSubview:numberLbl];
        }
        return cell;
    }
//    else if (indexPath.section == 4) {
//        static NSString *identifier = @"Cell4";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
//            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2+20, (60-21)/2, 100, 21)];
//            numberLbl.textColor = [UIColor whiteColor];
//            numberLbl.text = @"关于我们";
//            [cell addSubview:numberLbl];
//            return cell;
//        }
//
//    } else {
//        return nil;
//    }
    
    return nil;
}

-(void)switchIsChanged:(UISwitch *)sender{
    //将NSString 对象存储到 NSUserDefaults 中
    NSLog(@"%d",sender.on);
    NSString *passWord;
    if (sender.on) {
        passWord = @"1";
    }else{
    
        passWord = @"0";
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:passWord forKey:@"netRook"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                PersonInfoViewController *infoVc = [[PersonInfoViewController alloc] initWithUserFace:self.face];
                infoVc.allDict = _allDic;
                [self.navigationController pushViewController:infoVc animated:YES];
            } else if (indexPath.row == 1) {
                YEViewController *YEVC = [[YEViewController alloc] init];
                [self.navigationController pushViewController:YEVC animated:YES];
            }
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                alterPWViewController *alert = [[alterPWViewController alloc]init];
                [self.navigationController pushViewController:alert animated:YES];
                
            }else{
                
            }
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[RecuperationViewController new] animated:YES];
            } else if (indexPath.row == 1) {
                
                UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                shit.tag = 100;
                [shit showInView:self.view];
            } else if (indexPath.row == 2) {
                AboutUsViewController *aboutVc = [[AboutUsViewController alloc] init];
                [self.navigationController pushViewController:aboutVc animated:YES];
            }
            
        }
            break;
        case 3:
        {
            UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"退出", nil];
            shit.tag = 200;
            [shit showInView:self.view];
        }
            break;
        default:
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (actionSheet.tag == 100) {//说明是清除缓存
        
        switch (buttonIndex) {
            case 0:
                [self removeBenDi];
                break;
                
            default:
                break;
        }
        
    } else if (actionSheet.tag == 200) {//退出程序
        
        switch (buttonIndex) {
            case 0:
                [self quit];
                break;
                
            default:
                break;
        }
    }
    
}

//清除缓存
- (void)removeBenDi {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    [manager removeItemAtPath:caches1 error:nil];
    
    NSLog(@"---%@",caches1);
    
    NSString *caches2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    [manager removeItemAtPath:caches2 error:nil];
    
    _sizeLabel.text = @"0M";
    
}

-(void)quit
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userface"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"avatar_small"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WDC"];
    [defaults removeObjectForKey:@"balance"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fans"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"follow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    
    
    [Passport removeFile];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES/NO completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    //    UserLoginViewController *rVc = [[UIStoryboard storyboardWithName:@"" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
    //    [self presentViewController:rVc animated:YES completion:nil];
    //    [self.navigationController removeFromParentViewController];
    
    DLViewController *DLVC = [[DLViewController alloc] init];
    DLVC.typeStr = @"123";
    //    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
    //    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
    //    [self.navigationController presentViewController:DLVC animated:YES completion:nil];
    [self.navigationController pushViewController:DLVC animated:YES];
    
    
}

-(void)btnClick
{
    personDataViewController *p = [[personDataViewController alloc]init];
    [self.navigationController pushViewController:p animated:YES];
}

- (void)information {//获取到用户的资料
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"] forKey:@"user_id"];
    
    [manager userShow:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"%@",responseObject);
        _allDic = responseObject;
        _btn = [UIButton buttonWithType:0];
        _btn.tag = 5;
        _btn.frame = CGRectMake(10, 15, 50, 50);
        _btn.clipsToBounds = YES;
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:0];
        NSLog(@"%@",_allDic[@"data"][@"avatar_middle"]);
        NSLog(@"%@",_allDic[@"data"][@"uname"]);
        [_btn.layer setCornerRadius:25];

        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 200, 21)];
        _lbl.text = _allDic[@"data"][@"uname"];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//计算文件夹的大小
- (void)fileSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    //    NSString *caches1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *caches = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSLog(@"-----%@",caches);
    NSArray *subPaths = [manager subpathsAtPath:caches];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [caches stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    NSLog(@"-----%ld",totalBySize);
    _totaiZise = totalBySize;
    
}

- (NSInteger)fileSizeWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSLog(@"-----%@",path);
    NSArray *subPaths = [manager subpathsAtPath:path];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    NSLog(@"-----%ld",totalBySize);
    return totalBySize;
    
}



@end
