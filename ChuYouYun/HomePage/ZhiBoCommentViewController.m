//
//  ZhiBoCommentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoCommentViewController.h"

@interface ZhiBoCommentViewController ()

@property (strong ,nonatomic)NSString *ID;

@end

@implementation ZhiBoCommentViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}


@end
