//
//  LiveDetailThreeCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailThreeCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"



@implementation LiveDetailThreeCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 20, 20)];
    title.font = Font(15);
    title.text = @"机构信息";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:title];
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(title.frame) + SpaceBaside, 80, 80)];
    [self addSubview:_imageButton];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100,CGRectGetMaxY(title.frame) + SpaceBaside, MainScreenWidth - 120, 30)];
    _name.font = Font(20);
    [self addSubview:_name];
    
    _instDetail = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_name.frame), MainScreenWidth - 110, 40)];
    _instDetail.textColor = [UIColor grayColor];
    _instDetail.numberOfLines = 2;
    _instDetail.font = Font(14);
    [self addSubview:_instDetail];
    
    _fanNum = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_instDetail.frame), MainScreenWidth - 110, 20)];
    _fanNum.textColor = [UIColor grayColor];
    _fanNum.font = Font(15);
    [self addSubview:_fanNum];
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    

    NSString *urlStr = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"logo"]];
    [_imageButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    
    _name.text = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    if (dict[@"school_info"][@"title"] == nil) {
        _name.text = @"";
    }
    NSString *Tstr = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"info"]];
    NSString *detile = [self filterHTML:Tstr];
    _instDetail.text = detile;
    NSLog(@"111----%@",detile);
    if ([detile isEqualToString:@"(null)"]) {
        _instDetail.text = @"";
    }
    
    NSString *str1 = [NSString stringWithFormat:@"好评度：%@",[[[dict dictionaryValueForKey:@"school_info"] dictionaryValueForKey:@"count"] stringValueForKey:@"comment_rate"]];
    NSString *str2 = [NSString stringWithFormat:@" 课程数：%@",[[[dict dictionaryValueForKey:@"school_info"] dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"]];
    NSString *str3 = [NSString stringWithFormat:@"%@ 次学习",[[[dict dictionaryValueForKey:@"school_info"] dictionaryValueForKey:@"count"] stringValueForKey:@"learn_count"]];
    
    _fanNum.text = [NSString stringWithFormat:@"%@  %@  %@",str1,str2,str3];
    
    self.frame = CGRectMake(0, 0, MainScreenWidth, 140);
    
}


//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}



@end
