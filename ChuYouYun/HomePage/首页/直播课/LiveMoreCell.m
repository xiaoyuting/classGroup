//
//  LiveMoreCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveMoreCell.h"
#import "SYG.h"

@implementation LiveMoreCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SpaceBaside / 2, MainScreenWidth, 90)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 80, 75)];
    
    _headImageView.image = Image(@"你好");
    [backView addSubview:_headImageView];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, SpaceBaside,MainScreenWidth - 110, 20)];
    [backView addSubview:_nameLabel];
    _nameLabel.font = Font(16);
    _nameLabel.text = @"培养孩子良好的行为习惯";
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,MainScreenWidth - 80, 15)];
    [backView addSubview:_timeLabel];
    _timeLabel.text = @"11月10日 12:00 开课";
    _timeLabel.font = Font(14);
    _timeLabel.textColor = [UIColor grayColor];
    
    //钱和报名人数
    _moneyAndPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65 , MainScreenWidth - 110, 15)];
    [backView addSubview:_moneyAndPersonLabel];
    _moneyAndPersonLabel.numberOfLines = 2;
    _moneyAndPersonLabel.textColor = [UIColor grayColor];
    _moneyAndPersonLabel.font = Font(11);
    _moneyAndPersonLabel.text = @"￥1200  19人已报名";
    
    //贴子和成员
    _typeButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 65,90, 20)];
    [backView addSubview:_typeButton];
    [_typeButton setTitle:@"立即报名" forState:UIControlStateNormal];
    [_typeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _typeButton.titleLabel.font = Font(14);
    _typeButton.layer.borderColor = [UIColor orangeColor].CGColor;
    _typeButton.layer.borderWidth = 1;
    
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
//    NSURL *url = [NSURL URLWithString:dict[@"logo"]];
//    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
//    
//    _titleLabel.text = dict[@"title"];
//    _contentlabel.text = dict[@"info"];
//    _nameLabel.text = dict[@"doadmin"];;
    
}

@end
