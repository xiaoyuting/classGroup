//
//  BigWindCar_CommentCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "BigWindCar_CommentCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"



@implementation BigWindCar_CommentCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //名字 文本
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 60 , 60)];
    _imageButton.backgroundColor = [UIColor redColor];
    _imageButton.layer.cornerRadius = 30;
    _imageButton.layer.masksToBounds = YES;
    [self addSubview:_imageButton];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,70, 60 , 20)];
    _name.font = Font(14);
    _name.textColor = [UIColor grayColor];
    _name.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_name];
    

    //分数
    _score = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - 90 , 20)];
    _score.text = @"综合：5分 专业水平：5分 授课技巧：5分 教学态度：5分";
    _score.font = Font(12);
    _score.textColor = BlackNotColor;
    [self addSubview:_score];

        //详情
    _comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + SpaceBaside, 40, MainScreenWidth - 90 , 40)];
    _comment.font = Font(14);
    _comment.textColor = [UIColor grayColor];
    _comment.numberOfLines = 2;
    [self addSubview:_comment];

    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSString *urlStr = [dict stringValueForKey:@"userface"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
    _name.text = [dict stringValueForKey:@"username"];
    _comment.text = [dict stringValueForKey:@"review_description"];
    
    NSString *Str0 = [NSString stringWithFormat:@"%@分",dict[@"star"]];
    NSString *Str1 = [NSString stringWithFormat:@"%@分",dict[@"attitude"]];
    if ([dict[@"attitude"] isEqual:[NSNull null]]) {
        Str1 = @"";
    }
    NSString *Str2 = [NSString stringWithFormat:@"%@分",dict[@"professional"]];
    if ([dict[@"professional"] isEqual:[NSNull null]]) {
        Str2 = @"";
    }
    NSString *Str3 = [NSString stringWithFormat:@"%@分",dict[@"skill"]];
    if ([dict[@"skill"] isEqual:[NSNull null]]) {
        Str3 = @"";
    }
    _score.text = [NSString stringWithFormat:@"综合:%@ 专业水平:%@ 授课技巧:%@ 教学态度:%@",Str0,Str1,Str2,Str3];
    
}



@end
