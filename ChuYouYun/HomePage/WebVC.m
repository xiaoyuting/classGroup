//
//  WebVC.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/20.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
{
    CGRect rect;
}
@end

@implementation WebVC
-(id)initWithURL:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        self.urlString = urlStr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rect = [UIScreen mainScreen].applicationFrame;
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.view addSubview:web];
    [web loadHTMLString:self.urlString baseURL:nil];
}


@end
