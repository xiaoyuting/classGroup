//
//  ClsaaRnownCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClsaaRnownCell.h"
#import "SYG.h"


@implementation ClsaaRnownCell



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _bar = [[UILabel alloc] initWithFrame:CGRectMake(5, 10,5, 20)];
    _bar.backgroundColor = BasidColor;
    [self addSubview:_bar];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 20)];
    _title.numberOfLines = 2;
    _title.font = Font(18);
    _title.text = @"上课须知";
    _title.textColor = BlackNotColor;
    _title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_title];
    

    
}


@end
