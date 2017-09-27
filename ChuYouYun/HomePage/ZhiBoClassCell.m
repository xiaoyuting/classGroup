//
//  ZhiBoClassCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassCell.h"
#import "SYG.h"


@implementation ZhiBoClassCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _numberButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 13, 24, 24)];
    _numberButton.titleLabel.font = Font(20);
    _numberButton.backgroundColor = BasidColor;
    [_numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_numberButton];
    _numberButton.layer.cornerRadius = 12;
    _numberButton.layer.masksToBounds = YES;
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, MainScreenWidth - 120, 30)];
    _title.textColor = [UIColor blackColor];
    [self addSubview:_title];
    
    _type = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 10, 50, 30)];
    _type.font = Font(15);
    [self addSubview:_type];
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    _title.text = [dict stringValueForKey:@"title"];
    if ([[dict stringValueForKey:@"note"] isEqualToString:@"已结束"]) {
        _type.text = @"已结束";
    } else {
        _type.text = @"直播中";
    }
}



@end
