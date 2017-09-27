
//
//  ZXDTTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZXDTTableViewCell.h"

@implementation ZXDTTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 60)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];//加粗
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MainScreenWidth - 10 - 100, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor colorWithRed:128.f / 255 green:128.f / 255 blue:128.f / 255 alpha:1];
    [self addSubview:_timeLabel];
    
    //阅读
    _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 110, 70, 100, 20)];
    _readLabel.font = [UIFont systemFontOfSize:14];
    _readLabel.textColor = [UIColor colorWithRed:128.f / 255 green:128.f / 255 blue:128.f / 255 alpha:1];
    _readLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_readLabel];
    
    //摘要
    _ZYLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, MainScreenWidth - 20, 100)];
    _ZYLabel.font = [UIFont boldSystemFontOfSize:18];
    _ZYLabel.textColor = [UIColor colorWithRed:18.f / 255 green:18.f / 255 blue:18.f / 255 alpha:1];
    [self addSubview:_ZYLabel];

    //更多
    _GDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, MainScreenWidth - 20, 100)];
    _GDLabel.font = [UIFont systemFontOfSize:18];
    _GDLabel.textColor = [UIColor colorWithRed:51.f / 255 green:51.f / 255 blue:51.f / 255 alpha:1];
    [self addSubview:_GDLabel];

    
    
    
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.ZYLabel.text = text;
    //设置label的最大行数
    self.ZYLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.ZYLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    self.ZYLabel.frame = CGRectMake(self.ZYLabel.frame.origin.x, self.ZYLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height + 90 ;
    
    
    
    //计算出自适应的高度
//    frame.size.height = labelSize.height + 90;
    
    //计算当前正文的位置
    _GDLabel.frame = CGRectMake(10, CGRectGetMaxY(_ZYLabel.frame) + 10, MainScreenWidth - 20, 100);
    
    self.frame = frame;
}

//正文
-(void)setZWText:(NSString*)text {
    
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.GDLabel.text = text;
    //设置label的最大行数
    self.GDLabel.numberOfLines = 0;    
    
    CGRect labelSize = [self.GDLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    self.GDLabel.frame = CGRectMake(self.GDLabel.frame.origin.x, self.GDLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height;
    

    
    
    
    //计算出自适应的高度
//    frame.size.height = labelSize.height + 40;
    frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_GDLabel.frame));
    
    self.frame = frame;

}


@end
