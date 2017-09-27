//
//  SYGKCJJTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/1.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGKCJJTableViewCell.h"
#import "SYG.h"


@implementation SYGKCJJTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    //添加课程信息
    UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(5, 10,5, 20)];
    bar.backgroundColor = BasidColor;
    [self addSubview:bar];
    
   UILabel *_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 20)];
    _title.numberOfLines = 2;
    _title.font = Font(18);
    _title.text = @"课程信息";
    _title.textColor = BlackNotColor;
    [self addSubview:_title];
    _title.font = [UIFont boldSystemFontOfSize:18];
    
    //介绍
    _JJLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, MainScreenWidth - 20, 100)];
    _JJLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_JJLabel];

}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JJLabel.text = text;
    //设置label的最大行数
    self.JJLabel.numberOfLines = 0;
//    CGSize size = CGSizeMake(MainScreenWidth - 20, 1000);
    
    CGRect labelSize = [self.JJLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];

//    
//    CGSize labelSize = [self.JJLabel.text sizeWithFont:self.JJLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.JJLabel.frame = CGRectMake(self.JJLabel.frame.origin.x, self.JJLabel.frame.origin.y, labelSize.size.width, labelSize.size.height);
    //计算出自适应的高度
    frame.size.height = labelSize.size.height + 40;
    
    
    self.frame = frame;
}

- (void)dataSourceWithDict:(NSDictionary *)dict {
    
    NSString *info = [self filterHTML:dict[@"video_intro"]];
    [self setIntroductionText:info];
    
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}


@end
