//
//  SYGDPViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/3.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕


#import "SYGDPViewController.h"
#import "PlaceholderTextView.h"
#import "MyHttpRequest.h"

#import "SYG.h"
#import "MBProgressHUD+Add.h"
#import "BigWindCar.h"




@interface SYGDPViewController ()

{
    PlaceholderTextView *view1;
    PlaceholderTextView * view2;
}

@property (strong ,nonatomic)UITextField *SYGTextField;

@property (strong ,nonatomic)UIView *PFView;

@property (strong ,nonatomic)UIView *XJView;

@property (strong ,nonatomic)UIView *midView;

@property (strong ,nonatomic)NSString *XJStr;

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;
@property (strong ,nonatomic)NSMutableArray *classArray;

@property (strong ,nonatomic)NSString *buttonID;//标识 是哪个按钮

@property (strong ,nonatomic)UILabel *title0;
@property (strong ,nonatomic)UILabel *title1;
@property (strong ,nonatomic)UILabel *title2;
@property (strong ,nonatomic)UILabel *title3;



@end

@implementation SYGDPViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self addNav];
    [self addXJView];
    [self addMidView];
    [self addPLView];
    [self requestDataClassArray];
}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    _SYGArray = @[@"优",@"良",@"好"];
    _classArray = [NSMutableArray array];
    
}

- (void)addNav {
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 25, 50, 30)];
    [addButton setTitle:@"发布" forState:UIControlStateNormal];
    [addButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:addButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"写点评";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];

}


- (void)addXJView {
    
    //添加试图
    UIView *PFView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, MainScreenWidth, 40)];
    PFView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:PFView];
    _PFView = PFView;
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.8)];
    XLabel.backgroundColor = [UIColor colorWithRed:213.f / 255 green:213.f / 255 blue:213.f / 255 alpha:1];
    [PFView addSubview:XLabel];
    
    //添加评分文本
    UILabel *PFLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    PFLabel.text = @"评分：";
    PFLabel.textColor = [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    [PFView addSubview:PFLabel];
    
    //添加星级
    
    for (int i = 0 ; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80 + 22 * i + 10 * i, 9, 22, 22)];
        [button setBackgroundImage:[UIImage imageNamed:@"未评论@2x"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"已评论@2x"] forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(XJPL:) forControlEvents:UIControlEventTouchUpInside];
        [PFView addSubview:button];
        
    }
    

}

- (void)addMidView {

    _midView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, MainScreenWidth, 80)];
    _midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_midView];
    
    CGFloat ButtonW = 80;
    CGFloat ButtonH = 20;
    NSArray *titleArray = @[@"教学技能：",@"专业知识：",@"教学态度：",@"相应课程："];
    for (int i = 0 ; i < 3 ; i ++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + (MainScreenWidth / 2) * (i % 2), SpaceBaside + (i / 2) * (ButtonH + SpaceBaside) ,ButtonW, ButtonH)];
        title.text = titleArray[i];
        title.font = Font(14);
        [_midView addSubview:title];
        

        
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(90 + (MainScreenWidth / 2) * (i % 2),SpaceBaside + (i / 2) * (ButtonH + SpaceBaside) , MainScreenWidth / 2 - 90 - 20, 20)];
        text.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_midView addSubview:text];
        text.text = @"优";
        text.textAlignment = NSTextAlignmentCenter;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 20 + (MainScreenWidth / 2) * (i % 2),SpaceBaside + (i / 2) * (ButtonH + SpaceBaside) , 20, 20)];
        [button setImage:Image(@"灰色乡下") forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_midView addSubview:button];
   
        
        if (i == 0) {
            _title0 = text;
        } else if (i == 1) {
            _title1 = text;
        } else if (i == 2) {
            _title2 = text;
        } else if (i == 3) {
            _title3 = text;
        }
        
    }

    
    
}


- (void)addPLView {
    if (iPhone5o5Co5S) {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 200)];
    }
    
    else if(iPhone4SOriPhone4)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 130)];
    }
    
    
    else if(iPhone6)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 270)];
    }
    else if(iPhone6Plus)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 340)];
    }
    
    view2.placeholder=@"请输入点评内容...";
    view2.font = [UIFont systemFontOfSize:17];
    view2.placeholderFont=[UIFont systemFontOfSize:13];
    view2.layer.borderWidth=0.8;
    view2.layer.borderColor=[UIColor colorWithRed:213.f / 255 green:213.f / 255 blue:213.f / 255 alpha:1].CGColor;
    [self.view addSubview:view2];
//    view2.contentInset = UIEdgeInsetsMake(0, 18, 0, -15);
    

    
}


//点击评分的button
- (void)XJPL:(UIButton *)button {
    
    NSInteger K = button.tag;
    for (int i=0; i<5; i++) {
        if (i<K) {
            UIButton *nut=(UIButton*)[self.view viewWithTag:i+1];
            nut.selected=YES;
        }else{
            UIButton *nut=(UIButton*)[self.view viewWithTag:i+1];
            nut.selected=NO;
        }
    }
    //这里取到的tag值就是评论的星级个数
    _XJStr = [NSString stringWithFormat:@"%ld",K];


}


- (void)backPressed {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)buttonClick:(UIButton *)button {

    _buttonID = [NSString stringWithFormat:@"%ld",button.tag];
    
    if (button.tag == 3) {//课程
        [self addMoreClassView];
    } else {
        [self addMoreView];
    }

}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(50,MainScreenHeight,MainScreenWidth - 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(50, 64,MainScreenWidth - 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _buyView.center = self.view.center;
        //在view上面添加东西
        for (int i = 0 ; i < _SYGArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5,MainScreenWidth - 100, 40)];
            [button setTitle:_SYGArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _SYGArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , MainScreenWidth - 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}


- (void)addMoreClassView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(50,MainScreenHeight,MainScreenWidth - 100, _classArray.count * 40 + 5 * (_classArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(50, 64,MainScreenWidth - 100, _classArray.count * 40 + 5 * (_SYGArray.count - 1) + 50);
        _buyView.center = self.view.center;
        //在view上面添加东西
        for (int i = 0 ; i < _classArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5,MainScreenWidth - 100, 40)];
            [button setTitle:_classArray[i][@"title"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _classArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , MainScreenWidth - 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];

}


- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(50, MainScreenHeight,MainScreenWidth - 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)SYGButton:(UIButton *)button {
    
    if ([_buttonID integerValue] == 0) {
        _title0.text = button.titleLabel.text;
    } else if ([_buttonID integerValue] == 1) {
        _title1.text = button.titleLabel.text;
    } else if ([_buttonID integerValue] == 2) {
        _title2.text = button.titleLabel.text;
    } else if ([_buttonID integerValue] == 3) {
        _title3.text = button.titleLabel.text;
    }
    [self miss];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)addPressed {
    
    if ([_isTeacher isEqualToString:@"teacher"]) {//老师点评
        
        
        if (_XJStr == nil) {
            [MBProgressHUD showError:@"请给点评星级" toView:self.view];
            return;
        }
        if(view2.text.length==0)
        {
            [MBProgressHUD showError:@"请输入点评内容" toView:self.view];
        }
        
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [dic setValue:_ID forKey:@"teacher_id"];
        [dic setValue:view1.text forKey:@"title"];
        [dic setValue:view2.text forKey:@"content"];
        //评论星级
        [dic setValue:@"0" forKey:@"is_secret"];
        [dic setValue:_XJStr forKey:@"score"];
        
        //新增
        
        if ([_title0.text isEqualToString:@"优"]) {
            [dic setValue:@"1" forKey:@"skill"];
        } else if ([_title0.text isEqualToString:@"良"]) {
            [dic setValue:@"2" forKey:@"skill"];
        } else if ([_title0.text isEqualToString:@"好"]) {
            [dic setValue:@"3" forKey:@"skill"];
        }
        
        
        if ([_title1.text isEqualToString:@"优"]) {
            [dic setValue:@"1" forKey:@"professional"];
        } else if ([_title1.text isEqualToString:@"良"]) {
            [dic setValue:@"2" forKey:@"professional"];
        } else if ([_title1.text isEqualToString:@"好"]) {
            [dic setValue:@"3" forKey:@"professional"];
        }
        
        if ([_title2.text isEqualToString:@"优"]) {
            [dic setValue:@"1" forKey:@"attitude"];
        } else if ([_title2.text isEqualToString:@"良"]) {
            [dic setValue:@"2" forKey:@"attitude"];
        } else if ([_title2.text isEqualToString:@"好"]) {
            [dic setValue:@"3" forKey:@"attitude"];
        }
        
        if (_title0.text == nil || _title1.text == nil || _title2.text == nil) {
            [MBProgressHUD showError:@"请填写综合技能评分" toView:self.view];
            return;
        }
        
        NSLog(@"%@",dic);
        
        [manager getpublicPort:dic mod:@"Teacher" act:@"addReview" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"===__===%@",responseObject);
            NSString *msg = responseObject[@"msg"];
            if ([responseObject[@"code"] integerValue] == 0) {
                [MBProgressHUD showError:msg toView:self.view];
            } else {
                [MBProgressHUD showSuccess:@"点评成功" toView:self.view];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

        
    } else {
        
        if (_XJStr == nil) {
            [MBProgressHUD showError:@"请给点评星级" toView:self.view];
            return;
        }
        if(view2.text.length==0)
        {
            [MBProgressHUD showError:@"请输入点评内容" toView:self.view];
        } else {
            QKHTTPManager * manager = [QKHTTPManager manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            [dic setValue:_ID forKey:@"kzid"];
            [dic setValue:view1.text forKey:@"title"];
            [dic setValue:view2.text forKey:@"content"];
            //评论星级
            [dic setValue:_XJStr forKey:@"score"];
            [dic setValue:@"2" forKey:@"kztype"]; // 2为专辑 1 为课程
            if ([_isBlumStr isEqualToString:@"SYG"]) {//专辑
                [dic setValue:@"2" forKey:@"kztype"];
            }else {//课程
                [dic setValue:@"1" forKey:@"kztype"];
            }
            
            //新增
            
            if ([_title0.text isEqualToString:@"优"]) {
                [dic setValue:@"1" forKey:@"skill"];
            } else if ([_title0.text isEqualToString:@"良"]) {
                [dic setValue:@"2" forKey:@"skill"];
            } else if ([_title0.text isEqualToString:@"好"]) {
                [dic setValue:@"3" forKey:@"skill"];
            }
            
            
            if ([_title1.text isEqualToString:@"优"]) {
                [dic setValue:@"1" forKey:@"professional"];
            } else if ([_title1.text isEqualToString:@"良"]) {
                [dic setValue:@"2" forKey:@"professional"];
            } else if ([_title1.text isEqualToString:@"好"]) {
                [dic setValue:@"3" forKey:@"professional"];
            }
            
            if ([_title2.text isEqualToString:@"优"]) {
                [dic setValue:@"1" forKey:@"attitude"];
            } else if ([_title2.text isEqualToString:@"良"]) {
                [dic setValue:@"2" forKey:@"attitude"];
            } else if ([_title2.text isEqualToString:@"好"]) {
                [dic setValue:@"3" forKey:@"attitude"];
            }
            
            NSLog(@"----%@",dic);
            
            [manager AddReviews:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                NSString *msg = responseObject[@"msg"];
                if (![msg isEqualToString:@"ok"]) {
                    [MBProgressHUD showError :msg toView:self.view];
                } else {
                    [MBProgressHUD showSuccess:@"点评成功" toView:self.view];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showError:@"点评失败，请重试" toView:self.view];
            }];
        }
        
    }

}




-(void)requestDataClassArray
{
    
    BigWindCar *manager = [BigWindCar manager];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_ID forKey:@"id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [manager BigWinCar_getClassList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        NSArray *array = responseObject[@"data"];
        
        for (int i = 0 ; i < array.count; i ++ ) {
            NSArray *classArray = array[i][@"child"];
            
            for (int k = 0 ; k < classArray.count; k ++) {
                [_classArray addObject:classArray[k]];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
