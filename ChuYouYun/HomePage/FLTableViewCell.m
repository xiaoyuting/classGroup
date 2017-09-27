//
//  FLTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "FLTableViewCell.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation FLTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    _CLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, MainScreenWidth - 50, 20)];
    _CLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_CLabel];
    _CLabel.textColor = [UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1];
    
}


@end
