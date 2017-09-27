//
//  findOfEmailViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "findOfEmailViewController.h"
#import "alterPasswordViewController.h"
#import "findToPhoneViewController.h"
#import "checkEmailViewController.h"
#import "ZhiyiHTTPRequest.h"

@interface findOfEmailViewController ()

@end

@implementation findOfEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toPhone:(id)sender
{
    findToPhoneViewController *phone = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"findP"];
    [self presentViewController:phone animated:YES completion:nil];
}
- (IBAction)AlertPw:(id)sender
{
    [self findPasswordByEmail];
}
-(void)findPasswordByEmail
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.email.text forKey:@"email"];
    NSLog(@"%@",dic);
    [manager findPWDToEmail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSLog(@"%@   %@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([msg isEqualToString:@"ok"])
        {
            checkEmailViewController *ch = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"check"];
            [self presentViewController:ch animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"返回 " otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (IBAction)backOb:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
