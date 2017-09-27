//
//  ClassCharaCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassCharaCell.h"
#import "SYG.h"


@implementation ClassCharaCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //可试听
    _freeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 10, 40, 20)];
    _freeButton.titleLabel.font = Font(12);
    [_freeButton setTitle:@"试看" forState:UIControlStateNormal];
    [_freeButton setTitleColor:BasidColor forState:UIControlStateNormal];
    _freeButton.layer.borderWidth = 1;
    _freeButton.layer.borderColor = BasidColor.CGColor;
    [self addSubview:_freeButton];
    
    //名字 文本
    _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_freeButton.frame) + 10, SpaceBaside,MainScreenWidth - 120 , 20)];
    _title.text = @"出门装逼指南";
    _title.font = Font(13);
    [self addSubview:_title];
    if (iPhone5o5Co5S) {
        _title.font = Font(11);
    }
    
    //详情
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, SpaceBaside, 60 , 20)];
    _time.text = @"16分钟";
    _time.font = Font(12);
    _time.textColor = [UIColor grayColor];
    [self addSubview:_time];
//    _time.hidden = YES;

    //名字 文本
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 12, 16 , 16)];
    [_imageButton setBackgroundImage:Image(@"视频_灰色") forState:UIControlStateNormal];
    [self addSubview:_imageButton];
    
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.title.text = text;
    //设置label的最大行数
    self.title.numberOfLines = 0;
    
    CGRect labelSize = [self.title.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    if (iPhone5o5Co5S) {
        labelSize = [self.title.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} context:nil];
    }
    
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, labelSize.size.width, 20);
//    CGRectMake(CGRectGetMaxX(_freeButton.frame) + 10, SpaceBaside,MainScreenWidth - 120 , 20)
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, labelSize.size.width, 20);
    NSLog(@"%lf",labelSize.size.width);
    if (labelSize.size.width > MainScreenWidth - 200) {
        self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, MainScreenWidth - 200, 20);
    }
    
    _imageButton.frame = CGRectMake(CGRectGetMaxX(_title.frame) + SpaceBaside, SpaceBaside, 20, 20);
    _time.frame = CGRectMake(CGRectGetMaxX(_imageButton.frame) + SpaceBaside, SpaceBaside, 60, 20);
    
    self.frame = frame;
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    _freeButton.hidden = NO;
    
    
    if ([dict[@"is_shiting"] integerValue] == 1) {
        _freeButton.hidden = NO;
        _title.frame = CGRectMake(CGRectGetMaxX(_freeButton.frame) + 10, SpaceBaside,MainScreenWidth - 120 - CGRectGetWidth(_freeButton.frame) , 20);

    } else {
        _freeButton.hidden = YES;
        _title.frame = CGRectMake(SpaceBaside, SpaceBaside,MainScreenWidth - 120 , 20);
    }

    
    if ([dict[@"title"] isEqual:[NSNull null]]) {
        
    } else {
        _title.text = dict[@"title"];
    }

    if ([dict[@"duration"] isEqual:[NSNull null]]) {
        
    } else {
        NSString *timeStr = dict[@"duration"];
        _time.text = timeStr;
        if (timeStr.length > 6) {
            _time.text = [timeStr substringToIndex:8];
        }
    }
    
}






@end
