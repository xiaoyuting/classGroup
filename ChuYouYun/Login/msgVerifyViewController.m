//
//  msgVerifyViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "msgVerifyViewController.h"
#import "alterPasswordViewController.h"
@interface msgVerifyViewController ()

@end

@implementation msgVerifyViewController
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)alertPW:(id)sender
{
    alterPasswordViewController *aVC = [[UIStoryboard storyboardWithName:@"alterPasswordViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"alterPassword"];
    [self.navigationController pushViewController:aVC animated:YES];
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
