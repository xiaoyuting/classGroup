//
//  SYGCommandTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "SYGCommandTableViewCell.h"

@implementation SYGCommandTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    //头像
    _myHeadImage = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [self addSubview:_myHeadImage];
    
    //名字
    _myName = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 20)];
    _myName.textColor = [UIColor colorWithRed:136.f / 255 green:136.f / 255 blue:136.f / 255 alpha:1];
    [self addSubview:_myName];
    
    //日期
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
    _dayLabel.textColor = [UIColor colorWithRed:136.f / 255 green:136.f / 255 blue:136.f / 255 alpha:1];
    _dayLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_dayLabel];
    
    //删除
    _SCButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, 5, 80, 20)];
    [_SCButton setTitle:@"滑动删除" forState:UIControlStateNormal];
    [_SCButton setTitleColor:[UIColor colorWithRed:36.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateNormal];
    _SCButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_SCButton];
    
    //介绍
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, MainScreenWidth - 20, 100)];
    _JTLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_JTLabel];
    
    //评论View
    _otherView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, MainScreenWidth - 20, 50)];
    _otherView.backgroundColor = [UIColor colorWithRed:245.f / 255 green:245.f / 255 blue:245.f / 255 alpha:1];
    [self addSubview:_otherView];
    
    
    //评论人的名字
    _PLNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
    _PLNameLabel.font = [UIFont systemFontOfSize:16];
    [_otherView addSubview:_PLNameLabel];
    
    //回复的问题
    _HFLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_PLNameLabel.frame), 10, 200, 20)];
    _HFLabel.text = @"回复我的问答：";
    _HFLabel.textAlignment = NSTextAlignmentLeft;
    _HFLabel.textColor = [UIColor colorWithRed:136.f / 255 green:136.f / 255 blue:136.f / 255 alpha:1];
    [_otherView addSubview:_HFLabel];
    
    //更多的
    _GDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, MainScreenWidth - 70, 20)];
    [_otherView addSubview:_GDLabel];
    
    
    
    
}


//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.JTLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height + 80;
    

    
    
    //计算出自适应的高度
//    frame.size.height = labelSize.height + 50 + 10;
    _otherView.frame = CGRectMake(10, CGRectGetMaxY(_JTLabel.frame) + 10, MainScreenWidth - 20, 70);
    
    self.frame = frame;
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionTextName:(NSString*)text{
    //获得当前cell高度
//    CGRect frame = [self frame];
    //文本赋值
    self.PLNameLabel.text = text;
    //设置label的最大行数
    self.PLNameLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.PLNameLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.PLNameLabel.frame = CGRectMake(self.PLNameLabel.frame.origin.x, self.PLNameLabel.frame.origin.y, labelSize.size.width, labelSize.size.height);
//    frame.size.height = labelSize.size.height + 80;
    
    _HFLabel.frame = CGRectMake(CGRectGetMaxX(_PLNameLabel.frame) + 8, 10, 200, 20);
    NSLog(@"%@",NSStringFromCGRect(_HFLabel.frame));
    
}




@end
