//
//  ClassDetailInstCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassDetailInstCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"



@implementation ClassDetailInstCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _bar = [[UILabel alloc] initWithFrame:CGRectMake(5, 10,5, 20)];
    _bar.backgroundColor = BasidColor;
    [self addSubview:_bar];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 20)];
    _title.numberOfLines = 2;
    _title.font = Font(18);
    _title.text = @"机构信息";
    _title.font = [UIFont boldSystemFontOfSize:18];
    _title.textColor = BlackNotColor;
    [self addSubview:_title];
    
    _headerImage = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 80, 80)];
    [_headerImage setBackgroundImage:Image(@"机构") forState:UIControlStateNormal];
    [self addSubview:_headerImage];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,200,20)];
    _name.font = Font(18);
    _name.text = @"阳光学院";
    _name.textColor = BasidColor;
    [self addSubview:_name];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(100, 70,MainScreenWidth - 110,30)];
    _content.font = Font(16);
    _content.textColor = [UIColor grayColor];
    _content.text = @"这是个针对小孩子的教育";
    [self addSubview:_content];
    
    _info = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, MainScreenWidth - 140, 20)];
    _info.textColor = [UIColor grayColor];
    _info.font = Font(13);
    _info.text = @"北京-朝阳区  | 250门课程  | 3000次学习";
    [self addSubview:_info];
    
}

- (void)dataWithDic:(NSDictionary *)dict {
    
    NSLog(@"----%@",dict);
    
    NSString *urlStr = [dict stringValueForKey:@"logo"];
    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    
    _name.text = [dict stringValueForKey:@"title"];
    if ([dict[@"info"] isEqual:[NSNull null]]) {
        
    } else {
        _content.text = dict[@"info"];
    }
    
    NSString *locationStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"comment_rate"];
    NSString *videoNumStr =  [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"];
    NSString *learnNumStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"learn_count"];
    
    _info.text = [NSString stringWithFormat:@"%@好评率 | %@门课程 | %@次学习",locationStr,videoNumStr,learnNumStr];
    
}


@end
