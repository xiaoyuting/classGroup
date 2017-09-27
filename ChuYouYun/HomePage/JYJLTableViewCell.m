//
//  JYJLTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/14.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "JYJLTableViewCell.h"
#import "SYG.h"

@implementation JYJLTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 150, 20)];
    _typeLabel.text = @"支付";
    [self addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 130, 10, 120, 20)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = Font(14);
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_timeLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 40, MainScreenWidth - 110, 20)];
    _nameLabel.font = Font(14);
    [self addSubview:_nameLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 110, 40, 100, 20)];
    _moneyLabel.textColor = JHColor;
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_moneyLabel];
}




@end
