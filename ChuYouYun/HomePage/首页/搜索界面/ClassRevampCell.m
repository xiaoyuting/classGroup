//
//  ClassRevampCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassRevampCell.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SYG.h"
#import "Passport.h"

@implementation ClassRevampCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    int width;
    if (MainScreenWidth > 375) {
        
        width = 375;
    }else
    {
        width = MainScreenWidth;
    }
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, width / 5 * 2 - 10 + 2, 110 - 26)];
    _imageButton.userInteractionEnabled = NO;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 20, 20)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"mv"] forState:UIControlStateNormal];
    [self.contentView addSubview:_playButton];
    
    _audition = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, 40, 14)];
    [_audition setTitle:@"试听" forState:UIControlStateNormal];
    [_audition setTitleColor:BasidColor forState:UIControlStateNormal];
    _audition.layer.borderWidth = 1;
    _audition.titleLabel.font= Font(12);
    _audition.layer.borderColor = BasidColor.CGColor;
    [self.contentView addSubview:_audition];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_audition.frame) + 5, 13, MainScreenWidth - width / 5 * 2 - 13 - 50, 14)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    

    
    
    _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 42, 70, 30 + 5)];
    _teacherLabel.font = [UIFont systemFontOfSize:14];
    _teacherLabel.numberOfLines = 1;
    [self.contentView addSubview:_teacherLabel];
    _teacherLabel.textColor = [UIColor grayColor];
    
    
    _studyNum = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 83, 42,  MainScreenWidth - width / 5 * 2 - 13 - 10, 35)];
    _studyNum.font = [UIFont systemFontOfSize:14];
    _studyNum.text = @"报名人数：90";
    [self.contentView addSubview:_studyNum];
    _studyNum.textColor = [UIColor grayColor];
    
    _kinsOf = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, CGRectGetMaxY(_teacherLabel.frame) + 5, MainScreenWidth - width / 5 * 2 - 13 - 10 , 15)];
    _kinsOf.font = [UIFont systemFontOfSize:14];
    _kinsOf.textColor = [UIColor grayColor];
    _kinsOf.text = @"开始时间：90 课程数：22 价格：190 ";
    [self.contentView addSubview:_kinsOf];
    
    
}


- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type {
    
    NSLog(@"%@",dict);
    NSString *urlStr = [dict stringValueForKey:@"imageurl"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    _titleLabel.text = [dict stringValueForKey:@"video_title"];
    
    if ([[dict stringValueForKey:@"is_tlimit"] integerValue] == 0) {
        _audition.hidden = YES;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, MainScreenWidth - CGRectGetMaxX(_imageButton.frame) - 20, 14);
    } else {
        [_audition setTitle:@"试听" forState:UIControlStateNormal];
    }
    
    
    NSString *introStr = [self filterHTML:[dict stringValueForKey:@"video_intro"]];
    _teacherLabel.text = introStr;
    
    if ([dict[@"teacher_name"] isEqual:[NSNull null]]) {
        _teacherLabel.text = @"老师：";
    } else if ([dict[@"teacher_name"] isEqualToString:@""]) {
        _teacherLabel.text = @"老师：";
    } else if (dict[@"teacher_name"] != nil){
        _teacherLabel.text = [NSString stringWithFormat:@"%@",dict[@"teacher_name"]];
    } else {
        _teacherLabel.text = @"老师：";
    }

    _studyNum.text = [NSString stringWithFormat:@"报名人数：%@",[dict stringValueForKey:@"video_order_count"]];
    
    if ([type integerValue ] == 2) {
        _studyNum.text = [NSString stringWithFormat:@"报名人数：%@",[dict stringValueForKey:@"video_order_count"]];
    }
    
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"beginTime"]];
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"t_price"]];
    
    if ([type integerValue] == 1) {
        _kinsOf.text = [NSString stringWithFormat:@"章节数：%@  ¥：%@ ",sectionStr,priceStr];
        if ([priceStr integerValue] == 0) {
            _kinsOf.text = [NSString stringWithFormat:@"章节数：%@   免费",sectionStr];
        }
        
    } else if ([type integerValue] == 2) {
        _kinsOf.text = [NSString stringWithFormat:@"%@开课  ¥：%@ ",timeStr,priceStr];
        if ([priceStr integerValue] == 0) {
             _kinsOf.text = [NSString stringWithFormat:@"开课：%@   免费",timeStr];
        }
    }
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",[dict stringValueForKey:@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:BasidColor range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    //    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    
    [_XBLabel setAttributedText:needStr] ;
    
}


//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


@end
