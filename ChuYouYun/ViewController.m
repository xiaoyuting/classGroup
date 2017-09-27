//
//  ViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:3 target:nil selector:nil userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
