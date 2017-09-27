//
//  LookRecodeCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LookRecodeCell.h"
#import "SYG.h"
#import "Passport.h"


@implementation LookRecodeCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //添加很线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 1, 100)];
    lineButton.backgroundColor = [UIColor grayColor];
    [self addSubview:lineButton];
    
    //添加原点
    UIButton *DButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside / 2, SpaceBaside + SpaceBaside / 2, SpaceBaside, SpaceBaside)];
    DButton.layer.cornerRadius = SpaceBaside / 2;
    DButton.backgroundColor = BasidColor;
    [self addSubview:DButton];

    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * 2, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    [self addSubview:_timeLabel];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * 2,40,MainScreenWidth - 30, 20)];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"领域：幼儿教育、幼儿中心";
    _titleLabel.font = Font(15);
    _titleLabel.textColor = BlackNotColor;
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * 2, 70,MainScreenWidth - 30, 20)];
    [self addSubview:_nameLabel];
    _nameLabel.font = Font(14);
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.text = @"阳光学院";

    
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
//    CGRect frame = [self frame];
//    //文本赋值
//    self.nameLabel.text = text;
//    //设置label的最大行数
//    self.nameLabel.numberOfLines = 0;
//    
//    CGRect labelSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
//    
//    self.nameLabel.frame = CGRectMake(100, SpaceBaside, labelSize.size.width, 20);
//    _XJButton.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + SpaceBaside, SpaceBaside + 4, 80, 12);
//    self.frame = frame;
}

- (void)dataSourceWith:(NSDictionary *)dict {
    

    NSLog(@"dict ----- %@",dict);
    
    
    _timeLabel.text = [Passport formatterDate:dict[@"ctime"]];
    _titleLabel.text = dict[@"video_info"][@"video_title"];
    _nameLabel.text = dict[@"video_section"][@"title"];
    
    
}


@end
