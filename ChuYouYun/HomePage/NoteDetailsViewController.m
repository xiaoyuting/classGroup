//
//  NoteDetailsViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "NoteDetailsViewController.h"
#import "NoteTableViewCell.h"
#import "DetailCell.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "FirstNoteCell.h"

@interface NoteDetailsViewController ()
{
    NSArray *arr;
    CGRect rect;
}
@end

@implementation NoteDetailsViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [super viewWillAppear:animated];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的笔记";
    // Do any additional setup after loading the view from its nib.
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    arr = [[NSArray alloc]initWithObjects:@"你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行",@"你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据,你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据,你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据",@"你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据.你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据",@"你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据,你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据,你好，这是UILabel的自动换行测试内容，主要实现多行数据的自动换行，自适应不同行数的数据", nil];
    rect = [UIScreen mainScreen].applicationFrame;
    self.importText.delegate = self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString * labelStr = [arr objectAtIndex:0];
        
        CGSize labelSize = {0, 0};
        
        labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:14]
                     
                         constrainedToSize:CGSizeMake(225.0, 5000)
                     
                             lineBreakMode:NSLineBreakByWordWrapping];
        
        
        return labelSize.height + 80;

    }
    NSString * labelStr = [arr objectAtIndex:indexPath.row];
    
    CGSize labelSize = {0, 0};
    
    labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:14]
                 
                     constrainedToSize:CGSizeMake(225.0, 5000)
                 
                         lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return labelSize.height + 43;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 0;
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
        static NSString *Identifier = @"Cell";
        FirstNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"FirstNoteCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.noteText.text = [arr objectAtIndex:indexPath.row];
            cell.noteText.numberOfLines = 0;
        }
        return cell;
        }else
        {
            static NSString *Identifier = @"DCell";
            DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (!cell) {
                NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:nil options:nil];
                cell = [cellArr objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.headBtn sd_setBackgroundImageWithURL:nil forState:0 placeholderImage:[UIImage imageNamed:@"my_bg.png"]];
                NSString * labelStr = [arr objectAtIndex:indexPath.row];
                
                CGSize labelSize = {0, 0};
                
                labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:14]
                             
                                 constrainedToSize:CGSizeMake(225.0, 5000)
                             
                                     lineBreakMode:NSLineBreakByWordWrapping];
                cell.bgView.frame = CGRectMake(cell.bgView.frame.origin.x, cell.bgView.frame.origin.y, cell.bgView.frame.size.width, labelSize.height);
                cell.detailLbl.numberOfLines = 0;
                cell.detailLbl.text = labelStr;

        }
            return cell;
    }
    return nil;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 185 - (rect.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, rect.size.width, rect.size.height);
    }else
    {
        self.view.frame = CGRectMake(0.0f, +offset, rect.size.width, rect.size.height);
    }
    [UIView commitAnimations];
}
- (IBAction)sendClick:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame =CGRectMake(0, 0, rect.size.width, rect.size.height);
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
