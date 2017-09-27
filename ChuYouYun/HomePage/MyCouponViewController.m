//
//  MyCouponViewController.m
//  dafengche
//
//  Created by IOS on 16/9/20.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#import "MyCouponViewController.h"
#import "AppDelegate.h"
#import "UIColor+HTMLColors.h"
#import "freeTableViewCell.h"

@interface MyCouponViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{

    UIView *_view;
}
@property (strong, nonatomic) UITableView *tableView;
//输入框
@property (strong,nonatomic) UITextField *textField;

@end

@implementation MyCouponViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索
    [self creatTextFiled];
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _view.frame.size.height+_view.frame.origin.y +10, MainScreenWidth,MainScreenHeight - _view.frame.origin.y - _view.frame.size.height - 15)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self addNav];
}
-(void)creatTextFiled{
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 74, MainScreenWidth, 60*MainScreenHeight/667)];
    _view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:_view];
    //输入边框
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10*MainScreenWidth/375, 40*MainScreenHeight/667)];
    lab.text = @"";
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15*MainScreenWidth/375, 10*MainScreenHeight/667, 240*MainScreenWidth/375, 40*MainScreenHeight/667)];
    //textFiled两句左边空格
    self.textField.leftView = lab;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.textField.layer.borderWidth = 1.0;
    self.textField.text = @"";
    self.textField.clipsToBounds = YES;
    int num = 15*MainScreenHeight/667;
    self.textField.font = [UIFont systemFontOfSize:num];
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 8;
    self.textField.placeholder = [NSString stringWithFormat:@"在此输入优惠劵码"];
    [_view addSubview:self.textField];
    //查询按钮
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(270*MainScreenWidth/375, 10*MainScreenHeight/667, 90*MainScreenWidth/375, 40*MainScreenWidth/375)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#ffbb2d"];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    //[searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:searchBtn];
    searchBtn.layer.cornerRadius = 8;
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"我的优惠券";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}
- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理方法

//tableView询问有多少个分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//tableView询问某个分组有多少行（单元格）
//有多少个分组，就被调用多少次。
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

//tableview询问，某个分组，某个行的高度。
//每个行都会询问一次。要在视图中显示哪一行，就问哪一行
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSLog(@"询问高度%ld %ld",section,row);
    return 120*MainScreenHeight/667;
}

//设置分组的头部和尾部
//设置头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //貌似这个view的宽度设置没用
    
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20*MainScreenHeight/667)];
    headView.backgroundColor =  [UIColor colorWithRed:(16*15+5)/255.0 green:(16*15+5)/255.0 blue:(16*15+5)/255.0 alpha:1];
    return headView;
    
}
//设置每个分组头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20*MainScreenHeight/667;
    
}

//tableview询问每个单元格要显示的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //定义一个单元格id
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString * cellId=@"cellID";
    UIColor *noeffectColor = [UIColor colorWithHexString:@"#DEDEDE"];
    UIColor *effectColor = [UIColor colorWithHexString:@"#f96650"];
    //从cell队列里面找出id对应的可以复用的cell
    freeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell=[[freeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //添加自定义视图放在这里。比如往cell上面加一个button／imageView／label...；
        //添加的imageView／label...的内容更新放在下面。
        //文字内容过长省略号显示
        // cell.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 120*DeviceHight/667)];
        if (indexPath.section) {
            cell.imageV.image = [UIImage imageNamed:@"effective"];
            cell.backgroundColor = [UIColor colorWithRed:(16*15+5)/255.0 green:(16*15+5)/255.0 blue:(16*15+5)/255.0 alpha:1];
            cell.moneyLab.textColor = effectColor;
            cell.cateGaryLab.textColor = effectColor;
            
        }else{
            cell.backgroundColor = [UIColor colorWithRed:(16*15+5)/255.0 green:(16*15+5)/255.0 blue:(16*15+5)/255.0 alpha:1];
            cell.imageV.image = [UIImage imageNamed:@"noeffective"];
            //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noeffective"]];
            cell.moneyLab.textColor = noeffectColor;
            cell.cateGaryLab.textColor = noeffectColor;
            cell.firstLab.textColor = noeffectColor;
            cell.secondLab.textColor = noeffectColor;
            cell.lastLab.textColor = noeffectColor;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
//触摸事件，用户点下了屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //键盘消失
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
