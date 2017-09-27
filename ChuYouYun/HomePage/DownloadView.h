//
//  DownloadView.h
//  dafengche
//
//  Created by IOS on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@class ASIHTTPRequest;


@interface DownloadView : UIView {
    
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
    BOOL isPlay;
}


-(instancetype)initWithFrame:(CGRect)frame;

+(UIView *)getUrl:(NSURL *)url withArrar:(NSArray *)array;

@end
