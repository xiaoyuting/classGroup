//
//  QueryViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "QueryViewController.h"
#import "DealFromDateViewController.h"

@interface QueryViewController ()
{
    NSInteger lTag;
    NSDateFormatter * formatter;
}
@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"按时间查询";
    [self.datePicker setDatePickerMode:1];
    [self.datePicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_HK"]];
    NSString * dateStr = @"2015-1-1";
    formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate * date = [formatter dateFromString:dateStr];
    self.datePicker.date=date;
    
    self.actionTime.delegate = self;
    self.upTo.delegate = self;
}
-(void)datePickerClick:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    if (lTag == 0) {
        self.actionTime.text = [formatter stringFromDate:date];
    }else
    {
        self.upTo.text = [formatter stringFromDate:date];
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    lTag = textField.tag;
    NSLog(@"tag  %ld",(long)lTag);
}
- (IBAction)enterClick:(id)sender
{
    NSDate* upToDate = [formatter dateFromString:self.upTo.text];
    NSString *upToSp = [NSString stringWithFormat:@"%ld", (long)[upToDate timeIntervalSince1970]];
//    NSString *upToSp = [formatter stringFromDate:upToDate];
    
    NSDate* actionDate = [formatter dateFromString:self.actionTime.text];
    NSString *actionET = [NSString stringWithFormat:@"%ld", (long)[actionDate timeIntervalSince1970]];
//    NSString *actionET = [formatter stringFromDate:actionDate];
    
    DealFromDateViewController *deal = [[DealFromDateViewController alloc]initWithQueryDateNowDate:upToSp fromDate:actionET];
    
    [self.navigationController pushViewController:deal animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
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
