//
//  classDetailZeroCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "classDetailZeroCell.h"
#import "SYG.h"


@implementation classDetailZeroCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    _score = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 10,60, 20)];
    _score.numberOfLines = 2;
    _score.font = Font(18);
    _score.text = @"评分：";
    _score.textColor = [UIColor grayColor];
    [self addSubview:_score];
    
    _starButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_score.frame), 12,80,16)];
    [self addSubview:_starButton];
    
    _study = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 10,90,20)];
    _study.font = Font(16);
    _study.textColor = [UIColor grayColor];
    _study.text = @"学习人数：";
    [self addSubview:_study];
    
    _studyNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_study.frame), 10, 80, 20)];
    _studyNum.textColor = [UIColor grayColor];
    [self addSubview:_studyNum];
    
}

- (void)dataWithDic:(NSDictionary *)dict {
    NSLog(@"---%@",dict);

    NSString *score = [dict stringValueForKey:@"video_score"];
    NSString *imageStr = [NSString stringWithFormat:@"10%@@2x",score];
    [_starButton setBackgroundImage:Image(imageStr) forState:UIControlStateNormal];
    _studyNum.text = [dict stringValueForKey:@"video_order_count"];
    
}



@end
