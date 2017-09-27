//
//  SYGDPTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGDPTableViewCell.h"

@implementation SYGDPTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _HeadImageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    _HeadImageButton.layer.cornerRadius = 25;
    _HeadImageButton.layer.masksToBounds = YES;
    [self addSubview:_HeadImageButton];
    
    UILabel *PFLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 50, 20)];
    PFLabel.text = @"评分:";
    [self addSubview:PFLabel];
    
    _XJButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 12, 70, 12)];
    [self addSubview:_XJButton];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 10, 100, 20)];
    _TimeLabel.font = [UIFont systemFontOfSize:14];
    _TimeLabel.textColor = [UIColor colorWithRed:144.f / 255 green:144.f / 255 blue:144.f / 255 alpha:1];
    _TimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_TimeLabel];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 80, 20)];
    _NameLabel.font = [UIFont systemFontOfSize:14];
    _NameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_NameLabel];
    
    //介绍
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, MainScreenWidth - 20, 100)];
    _JTLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_JTLabel];
    
    _DZButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_DZButton];
    
    _DZLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _DZLabel.font = [UIFont systemFontOfSize:14];
    _DZLabel.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self addSubview:_DZLabel];
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(MainScreenWidth - 100, 1000);
    
    CGSize labelSize = [self.JTLabel.text sizeWithFont:self.JTLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应的高度
    frame.size.height = labelSize.height + 40;
    
    //计算出点赞的位置
    _DZButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_JTLabel.frame), 20, 20);
    _DZLabel.frame = CGRectMake(MainScreenWidth - 30, CGRectGetMaxY(_JTLabel.frame), 30, 20);
    
    self.frame = frame;
}


@end
