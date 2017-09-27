//
//  InstationClassViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationClassViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"

#import "InstationClassVideoCell.h"
#import "InstationClassCell.h"
#import "SYGClassTableViewCell.h"

#import "classDetailVC.h"
#import "ZhiBoMainViewController.h"
#import "InstAllClassViewController.h"
#import "ClassRevampCell.h"



@interface InstationClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *classArray;

@end

@implementation InstationClassViewController

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
    [self interFace];
//    [self addNav];
    [self addTableView];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //接受通知（将机构的id传过来）
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetInstitonSchoolID:) name:@"NotificationInstitionSchoolID" object:nil];
}

#pragma mark --- 通知

- (void)GetInstitonSchoolID:(NSNotification *)Not {
    _schoolID = (NSString *)Not.userInfo[@"school_id"];
    [self netWorkInstitutionClassList];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"机构";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStylePlain];
    _tableView.rowHeight = 110;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_classArray.count > 4) {
        return 4;
    } else {
        return _classArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"cell1";
    //自定义cell类
    
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _classArray[indexPath.row];
    NSString *type = dict[@"type"];
    [cell dataWithDict:dict withType:type];
    
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"t_price"]];
    
    if ([type integerValue] == 1) {
        cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@  ¥：%@ ",sectionStr,priceStr];
        if ([priceStr integerValue] == 0) {
            cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@   免费",sectionStr];
        }
        
    } else if ([type integerValue] == 2) {
        cell.kinsOf.text = [NSString stringWithFormat:@"%@开课  ¥：%@ ",timeStr,priceStr];
        if ([priceStr integerValue] == 0) {
            cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@   免费",sectionStr];
        }
    }

    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_dataArray.count == 0) {
        return 60;
    } else {
        return 110;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.userInteractionEnabled = YES;
    
    //添加查看全部的课程
    UIButton *allClassButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 10, 100, 20)];
    [allClassButton setTitle:@"查看全部课程" forState:UIControlStateNormal];
    allClassButton.titleLabel.font = Font(12);
    [allClassButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allClassButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    allClassButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    allClassButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [allClassButton addTarget:self action:@selector(allClassButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    allClassButton.tag = 600;
    [footView addSubview:allClassButton];
    if (_dataArray.count == 0) {
        allClassButton.frame = CGRectMake(MainScreenWidth / 2 - 50,10 ,100, 1);
        allClassButton.hidden = YES;
        footView.frame = CGRectMake(0, 0, MainScreenWidth, 40);
    }

    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, SpaceBaside)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footView addSubview:lineButton];
    if (_dataArray.count == 0) {
        lineButton.hidden = YES;
        lineButton.frame = CGRectMake(0, 0, MainScreenWidth, 0.00001);
    }
    
    
    //添加班课
    NSArray *textArray = @[@"机构ID",@"机构二维码名片"];
    CGFloat textH = 30;
    
    for (int i = 0 ; i < 2 ; i ++) {
        UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i , 200, textH)];
        class.text = textArray[i];
        class.font = Font(13);
        [footView addSubview:class];
        
        //添加ID 文本
        if (i == 0) {
            UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 30, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i + 5, 30, textH - 10)];
            IDLabel.text = [NSString stringWithFormat:@"%@",_schoolID];
            IDLabel.textColor = [UIColor grayColor];
            IDLabel.textAlignment = NSTextAlignmentCenter;
            IDLabel.font = Font(14);
            [footView addSubview:IDLabel];
            
        } else if (i == 1) {
            UIButton *IDButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 20, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i + 5, textH - 10, textH - 10)];
            [IDButton setImage:Image(@"二维码") forState:UIControlStateNormal];
            [footView addSubview:IDButton];
            
        }
        
    }
    
    
    //添加点击二维码的按钮
    UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textH + CGRectGetMaxY(lineButton.frame), MainScreenWidth, textH)];
    codeButton.backgroundColor = [UIColor clearColor];
    [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:codeButton];
    
    UIButton *lineButton2 = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside,CGRectGetMaxY(lineButton.frame) + textH + 1 , MainScreenWidth, 1)];
    lineButton2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footView addSubview:lineButton2];
    
    
    double getHight;
    if (_classArray.count >= 4) {
        getHight = 4 * 110;
    } else {
        getHight = _classArray.count * 110;
    }
    
    NSString *getHightStr = [NSString stringWithFormat:@"%lf",getHight];
    
    //发送知道
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InsClassScrollHight" object:getHightStr];
    
    
    NSLog(@"%lf",CGRectGetMaxY(footView.frame));

    return footView;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",_dataArray[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//课程的时候
        if ([_dataArray[indexPath.row][@"type"] integerValue] == 1) {//课程

            NSString *Cid = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
            NSString *Price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
            NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
            NSString *VideoAddress = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
            NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
            
            classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
            classDetailVc.videoTitle = Title;
            classDetailVc.img = ImageUrl;
            classDetailVc.video_address = VideoAddress;
            [self.navigationController pushViewController:classDetailVc animated:YES];
        } else if ([_dataArray[indexPath.row][@"type"] integerValue] == 2) {
            
//            NSString *address = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
            NSString *Cid = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"]];
            NSString *Price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
            NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
            NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
    
            ZhiBoMainViewController *MainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
            [self.navigationController pushViewController:MainVc animated:YES];
        }
        
    }
    
}


#pragma mark --- 事件监听

- (void)allClassButtonCilck:(UIButton *)button {
    InstAllClassViewController *allClassVc = [[InstAllClassViewController alloc] init];
    allClassVc.schoolID = _schoolID;
    [self.navigationController pushViewController:allClassVc animated:YES];
}

- (void)codeButtonClick {
    NSLog(@"二维码");
}

#pragma mark --- 计算可以滚动的范围

- (void)getTheScrollFrame {
    
    //tableView 的总高度为 每个cell 的 高度 * 个数 + 底部试图的高度
    CGFloat allFrame = _classArray.count * 100 + 110;
    NSLog(@"%lf",allFrame);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%lf",allFrame] forKey:@"frame"];
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationInstClassScrollFrame" object:nil userInfo:dict];
    
}

#pragma mark --- 网络请求

- (void)netWorkInstitutionClassList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"5" forKey:@"count"];
    [dic setObject:_schoolID forKey:@"school_id"];
    
    [manager BigWinCar_GetSchoolClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            return;
        }
        _dataArray = responseObject[@"data"];
        _classArray = responseObject[@"data"];
        _tableView.frame = CGRectMake(0, 64, MainScreenWidth, _classArray.count * 100 + 120);
        [_tableView reloadData];
        [self getTheScrollFrame];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _dataArray = [NSArray array];
    }];
    
}



@end
