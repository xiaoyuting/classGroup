//
//  DownViewController.m
//  dafengche
//
//  Created by IOS on 16/11/24.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "DownViewController.h"
#import "ASIHTTPRequest.h"


@interface DownViewController (){

    unsigned long long Recordull;
    ASIHTTPRequest *videoRequest;


}

@end

@implementation DownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downWithurl:@""];

}
- (void)downWithurl:(NSString *)urlStr {
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    //    playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);
    //    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:urlStr];
    //    wmPlayer.closeBtn.hidden = YES;
    //    [self.view addSubview:wmPlayer];
    //    [wmPlayer.player play];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    //下载完存储目录
    [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",@"nihao"]]];
    //临时存储目录
    [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",@"nihao"]]];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setDouble:total forKey:@"file_length"];
        Recordull += size;//Recordull全局变量，记录已下载的文件的大小
        
    }];
    //断点续载
    [request setAllowResumeForFileDownloads:YES];
    [request startAsynchronous];
    videoRequest = request;
    
    
    
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
