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
    
//    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 52, 72)];
//    [_imageButton setBackgroundImage:Image(@"试卷@2x") forState:UIControlStateNormal];
//    [self addSubview:_imageButton];
    
    //添加标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,MainScreenWidth - 10 - 70, 40)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    //添加人数
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, 10, 30, 20)];
    _personLabel.textAlignment = NSTextAlignmentRight;
    _personLabel.textColor = [UIColor colorWithRed:255.f / 255 green:127.f / 255 blue:0.f / 255 alpha:1];
    _personLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_personLabel];
    
    //作答
    _ZDLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 10, 60, 20)];
    _ZDLabel.text = @"人参考";
    _ZDLabel.font = [UIFont systemFontOfSize:12];
    _ZDLabel.textColor = [UIColor colorWithRed:153.f / 255 green:153.f / 255 blue:153.f / 255 alpha:1];
    [self addSubview:_ZDLabel];
    
    //添加是否参加考试
    _CJLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 15)];
    _CJLabel.textColor = XXColor;
    _CJLabel.font = Font(11);
    [self addSubview:_CJLabel];
    
    //时长
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(148 -68, 50, MainScreenWidth - 158, 15)];
    _timeLabel.textColor = XXColor;
    _timeLabel.font = Font(11);
    [self addSubview:_timeLabel];

    //考试日期
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 67, MainScreenWidth - 88, 15)];
    _dateLabel.textColor = XXColor;
    _dateLabel.font = Font(11);
    [self addSubview:_dateLabel];
  
}

- (void)dataWithDict:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    self.titleLabel.text = dict[@"exam_name"];
    self.personLabel.text = [NSString stringWithFormat:@"%@",dict[@"count"]];
    self.CJLabel.text = dict[@"exam_describe"];
    if ([dict[@"is_test"] integerValue] == 0) {
        self.CJLabel.text = @"第0次参加考试";
        self.CJLabel.text = [NSString stringWithFormat:@"第%@次参加考试",[dict stringValueForKey:@"test_number" defaultValue:@"0"]];
    } else {
        self.CJLabel.text = @"已参加考试";
    }
    
    self.timeLabel.frame = CGRectMake(100, 50, MainScreenWidth - 158, 15);
    self.timeLabel.text = [NSString stringWithFormat:@"考试时长：%@分钟",dict[@"exam_total_time"]];
    NSString *Str1 = dict[@"exam_begin_time"];
    NSString *Str2 = dict[@"exam_end_time"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",Str1,Str2];

}



@end
