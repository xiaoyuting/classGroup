//
//  ZXKSTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/5.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//


#import "ZXKSTableViewCell.h"
#import "SYG.h"

@implementation ZXKSTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 52, 62)];
    [_imageButton setBackgroundImage:Image(@"试卷@2x") forState:UIControlStateNormal];
    [self addSubview:_imageButton];
    
    //添加标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, 150, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    //添加人数
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 10, 40, 20)];
    _personLabel.textAlignment = NSTextAlignmentRight;
    _personLabel.textColor = [UIColor colorWithRed:255.f / 255 green:127.f / 255 blue:0.f / 255 alpha:1];
    _personLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_personLabel];
    
    //作答
    _ZDLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 10, 50, 20)];
    _ZDLabel.text = @"人次作答";
    _ZDLabel.font = [UIFont systemFontOfSize:12];
    _ZDLabel.textColor = [UIColor colorWithRed:153.f / 255 green:153.f / 255 blue:153.f / 255 alpha:1];
    [self addSubview:_ZDLabel];
    
    //添加是否参加考试
    _CJLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 40, 60, 15)];
    _CJLabel.textColor = XXColor;
    _CJLabel.font = Font(11);
    [self addSubview:_CJLabel];
    
    //时长
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 40, MainScreenWidth - 158, 15)];
    _timeLabel.textColor = XXColor;
    _timeLabel.font = Font(11);
    [self addSubview:_timeLabel];

    //考试日期
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 57, MainScreenWidth - 88, 15)];
    _dateLabel.textColor = XXColor;
    _dateLabel.font = Font(11);
    [self addSubview:_dateLabel];
    
    
}



@end
