//
//  UserHomeViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "UserHomeViewController.h"
#import "teacherDetailTabelViewCellTableViewCell.h"
#import "MyMsgViewController.h"
#import "AttentionViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
@interface UserHomeViewController ()

@end

@implementation UserHomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *titleArr = [[NSArray alloc]initWithObjects:@"课程",@"问答",@"笔记",@"关注",@"粉丝", nil];
    self.bgIView.userInteractionEnabled = YES;
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    _tableView.showsVerticalScrollIndicator = NO;
    int lblX = (r.size.width-200)/5;
    
    
    for (int i = 0; i < 5; i++)
    {
        UILabel *numberlbl = [[UILabel alloc]initWithFrame:CGRectMake((lblX+40)*i+lblX/2, 230, 40, 21)];
        numberlbl.tag = i;
        numberlbl.text = @"0";
        numberlbl.textAlignment = UITextAlignmentCenter;
        numberlbl.textColor = [UIColor whiteColor];
#pragma lbl标题
        [self.bgIView addSubview:numberlbl];
        
        UILabel *titlelbl = [[UILabel alloc]initWithFrame:CGRectMake((lblX+40)*i+lblX/2, 256, 40, 21)];
        titlelbl.text = [titleArr objectAtIndex:i];
        titlelbl.textAlignment = UITextAlignmentCenter;
        [self.bgIView addSubview:titlelbl];
        
        UIButton *optionBtn = [UIButton buttonWithType:0];
        optionBtn.frame = CGRectMake((lblX+40)*i+lblX/2, 5, 40, 50);
        optionBtn.tag = i;
        [optionBtn setBackgroundColor:[UIColor lightGrayColor]];
        [optionBtn addTarget:self action:@selector(optionsClick:) forControlEvents:0];
        [self.barView addSubview:optionBtn];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

        NSString *title = @"他的课程";
        return title;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 100, 30)];
        lbl.text = @"TA的课程";
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];;
        [view addSubview:lbl];
        return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString * CellStr = @"courseCell";
        teacherDetailTabelViewCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
        if(!cell)
        {
            NSArray *xibArr = [[NSBundle mainBundle]loadNibNamed:@"teacherDetailTabelViewCellTableViewCell" owner:nil options:nil];
            for (id obj in xibArr) {
                cell = (teacherDetailTabelViewCellTableViewCell *)obj;
                break;
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
            return cell;
}


- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)headClick:(id)sender
{
}
- (IBAction)myMsg:(id)sender
{
    MyMsgViewController *m = [[MyMsgViewController alloc]init];
    [self.navigationController pushViewController:m animated:YES];
}
- (IBAction)attention:(id)sender
{
    AttentionViewController *a = [[AttentionViewController alloc]init];
    [self.navigationController pushViewController:a animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
