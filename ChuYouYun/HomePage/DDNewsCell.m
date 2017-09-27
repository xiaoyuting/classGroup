//
//  DDNewsCell.m
//  dafengche
//
//  Created by IOS on 17/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "DDNewsCell.h"
#import "UIView+Utils.h"
#import "UIButton+WebCache.h"
#import "SYG.h"
#import "Passport.h"

@implementation DDNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


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
    }else{
        width = MainScreenWidth;
    }
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, width / 5 * 2 - 10 + 2, 110 - 26)];
    _imageButton.userInteractionEnabled = NO;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 20, 20)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"mv"] forState:UIControlStateNormal];
    [self.contentView addSubview:_playButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, MainScreenWidth - width / 5 * 2 - 13, 14)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _audition = [[UIButton alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 13 + 14 + 5 - 2 + 5, 60, 20)];
    [_audition setTitle:@"可试听" forState:UIControlStateNormal];
    [_audition setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _audition.layer.borderWidth = 1;
    _audition.titleLabel.font= Font(14);
    _audition.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.contentView addSubview:_audition];
    
    _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 42 + 10, MainScreenWidth - width / 5 * 2 - 13 - 10, 30 + 5)];
    _teacherLabel.font = [UIFont systemFontOfSize:13];
    _teacherLabel.numberOfLines = 2;
    [self.contentView addSubview:_teacherLabel];
    
    _studyNum = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13 + 25 + 5 + 40, 42 + 10,  MainScreenWidth - width / 5 * 2 - 13 - 10, 35)];
    _studyNum.font = [UIFont systemFontOfSize:13];
    _studyNum.text = @"报名人数：90";
    [self.contentView addSubview:_studyNum];
    
    _kinsOf = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_teacherLabel.frame) + 25, MainScreenWidth - 2 * SpaceBaside, 15)];
    _kinsOf.font = [UIFont systemFontOfSize:14];
    _kinsOf.textColor = [UIColor grayColor];
    _kinsOf.text = @"开始时间：90 课程数：22 价格：190 ";
    [self.contentView addSubview:_kinsOf];
}

- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type {
    
    NSLog(@"%@",dict);
    NSString *urlStr = dict[@"imageurl"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    _titleLabel.text = dict[@"video_title"];
    
    NSString *introStr = [self filterHTML:dict[@"user"][@"uname"]];
    _teacherLabel.text = introStr;
    _teacherLabel.text = @"周杰伦";
    _studyNum.text = [NSString stringWithFormat:@"报名人数：%@",dict[@"video_order_count"]];
    
    if ([type integerValue] == 1) {
        
        _kinsOf.text = @" 直播 开始时间：90 课程数：22 价格：190 ";
        _kinsOf.text = [NSString stringWithFormat:@"课程 开始时间：%@  课程数：%@  价格：%@",dict[@"video_title"],dict[@"video_order_count"],dict[@"t_price"]];
        
    } else if ([type integerValue] == 2) {
        
        _kinsOf.text = @" 直播 开始时间：90 课程数：22 价格：190 ";
        _kinsOf.text = [NSString stringWithFormat:@"课程开始时间：%@    课程数：%@    价格：%@元",[Passport glTime:dict[@"begin_time"]],dict[@"video_order_count"],dict[@"t_price"]];
    }
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",dict[@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:BasidColor range:NSMakeRange(0, XBStr.length)];
    
    //设置字体加错
    //[needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
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
