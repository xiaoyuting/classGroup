//
//  FindPasswordViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "msgVerifyViewController.h"
@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backOb:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeToPhone:(id)sender
{
    
}
- (IBAction)msgVerify:(id)sender
{
    msgVerifyViewController *msg  = [[UIStoryboard storyboardWithName:@"msgVerifyViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"msgV"];
    [self presentViewController:msg animated:YES completion:nil];
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
