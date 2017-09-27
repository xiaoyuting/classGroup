//
//  TIXingLable.m
//  ChuYouYun
//
//  Created by IOS on 16/6/28.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TIXingLable.h"
#define DeviceHight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@implementation TIXingLable

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self initUI];

    }
    return self;
}
-(void)initUI{
    
    self.textColor = [UIColor clearColor];
    self.text =  @"数据为空，刷新重试";
    self.font = [UIFont systemFontOfSize:14];
    self.textAlignment = NSTextAlignmentCenter;
}

-(void)setTextColor:(UIColor *)textColor{

    [super setTextColor:textColor];
}
-(void)setFont:(UIFont *)font{

    [super setFont:font];
}
@end
