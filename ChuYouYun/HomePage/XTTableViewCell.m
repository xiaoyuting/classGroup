//
//  XTTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/13.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "XTTableViewCell.h"
#import "SYG.h"

@implementation XTTableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    
    //介绍
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MainScreenWidth - 20, 40)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];

    
    //日期
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, MainScreenWidth - 40, 15)];
    _timeLabel.textColor = [UIColor colorWithRed:136.f / 255 green:136.f / 255 blue:136.f / 255 alpha:1];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLabel];
    
    
    
    _TXButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 14, 8, 8)];
    _TXButton.backgroundColor = [UIColor redColor];
    _TXButton.layer.cornerRadius = 4;
    [self addSubview:_TXButton];
     
    
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.titleLabel.text = text;
    //设置label的最大行数
    self.titleLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    
    _timeLabel.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, MainScreenWidth - 20, 15);
    frame.size.height = labelSize.size.height + 45;
    
    self.frame = frame;
}



@end
