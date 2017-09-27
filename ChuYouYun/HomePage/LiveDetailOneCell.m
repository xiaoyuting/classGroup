//
//  LiveDetailOneCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailOneCell.h"
#import "SYG.h"


@implementation LiveDetailOneCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _liveTitle = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 10, MainScreenWidth - 20, 30)];
    _liveDetail.font = Font(20);
    _liveTitle.backgroundColor = [UIColor whiteColor];
    [self addSubview:_liveTitle];

    _money = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_liveTitle.frame), 150, 20)];
    _money.textColor = BasidColor;
    [self addSubview:_money];
    
    _oldMoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_money.frame) + 20,  CGRectGetMaxY(_liveTitle.frame), 200, 20)];
    _oldMoney.font = Font(15);
    [self addSubview:_oldMoney];
    
    //
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_oldMoney.frame) + SpaceBaside, MainScreenWidth - 20, 20)];
    title.text = @"课程信息";
    [self addSubview:title];
    
    _liveDetail = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(title.frame) + SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 30)];
    _liveDetail.textColor = [UIColor grayColor];
    _liveDetail.font = Font(13);
    [self addSubview:_liveDetail];
    
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"%@",dict);
    _liveTitle.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_title"]];
    _money.text = [NSString stringWithFormat:@"¥ %@",[dict stringValueForKey:@"t_price"]];
    if ([[dict stringValueForKey:@"t_price"] integerValue] == 0) {
        _money.text = @"免费";
        _money.textColor = [UIColor greenColor];
    }
    
    _money.frame = CGRectMake(SpaceBaside, CGRectGetMaxY(_liveTitle.frame),_money.text.length * 20 + 10, 20);
    _oldMoney.frame = CGRectMake(CGRectGetMaxY(_money.frame) + 50,  CGRectGetMaxY(_liveTitle.frame), 200, 20);
    
    _oldMoney.text =  [NSString stringWithFormat:@"¥ %@",[dict stringValueForKey:@"v_price"]];
    NSString *moneyStr =  [NSString stringWithFormat:@"原价：¥ %@",[dict stringValueForKey:@"v_price"]];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:moneyStr attributes:attribtDic];
    // 赋值
    _oldMoney.attributedText = attribtStr;
    
    NSString *detailStr = [self filterHTML:[dict stringValueForKey:@"video_intro"]];
    [self setIntroductionText:detailStr];
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


#pragma mark --- 文本自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _liveDetail.text = text;
    //设置label的最大行数
    _liveDetail.numberOfLines = 0;
    
    CGRect labelSize = [_liveDetail.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _liveDetail.frame = CGRectMake(10, CGRectGetMaxY(_money.frame) + 40, MainScreenWidth - 20, labelSize.size.height );
    
    self.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 120);
}






@end
