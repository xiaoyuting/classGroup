//
//  ClassDetailOneCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassDetailOneCell.h"
#import "SYG.h"
#import "Passport.h"


@implementation ClassDetailOneCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 40)];
    _title.numberOfLines = 2;
    _title.font = Font(18);
    _title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_title];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(0, 50,80,30)];
    _price.font = Font(20);
    _price.textColor = [UIColor orangeColor];
    _price.text = @"￥888";
    [self addSubview:_price];
    
    _ordPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame) + 30, 50,200,30)];
    _ordPrice.font = Font(16);
    _ordPrice.textColor = [UIColor grayColor];
    _ordPrice.text = @"￥999";
    [self addSubview:_ordPrice];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame) + 30, 14.5 + 50, 50, 1)];
    _line.backgroundColor = [UIColor grayColor];
    [self addSubview:_line];
    
    CGFloat ButtonW = MainScreenWidth / 3;
//    CGFloat ButtonH = 30;
    
    NSArray *imageArray = @[@"开课",@"在线授课",@"好评"];
    NSArray *titleArray = @[@"2016-12-01开课",@"在线授课",@"100%好评"];
    NSArray *title2Array = @[@"80节",@"手机观看",@"888条"];
    
    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 50, ButtonW, ButtonW)];
        if (iPhone5o5Co5S) {
            button.frame = CGRectMake(ButtonW * i, 45, ButtonW, ButtonW);
        } else if (iPhone6) {
            button.frame = CGRectMake(ButtonW * i, 30, ButtonW, ButtonW);
        } else if (iPhone6Plus) {
            button.frame = CGRectMake(ButtonW * i, 30, ButtonW, ButtonW);
        }
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ButtonW * i, 120, ButtonW, 20)];
        label.text = titleArray[i];
        label.font = Font(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = BlackNotColor;
        [self addSubview:label];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ButtonW * i, 140, ButtonW, 20)];
        label2.font = Font(14);
        label2.text = title2Array[i];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor grayColor];
        [self addSubview:label2];
        
        
        if (i == 0) {
            _time = label;
            _classNum = label2;
        } else if (i == 1) {
            
        } else if (i == 2) {
            _good = label;
            _num = label2;
        }
    }
}

- (void)dataWithDic:(NSDictionary *)dict {
    NSLog(@"---%@",dict);
    _title.text = [dict stringValueForKey:@"video_title"];
    _price.text = [NSString stringWithFormat:@"￥%@",[[dict dictionaryValueForKey:@"mzprice"] stringValueForKey:@"price"]];
    if ([[[dict dictionaryValueForKey:@"mzprice"] stringValueForKey:@"price"] integerValue] == 0) {
        _price.text = @"免费";
    }
    _ordPrice.text = [NSString stringWithFormat:@"￥%@",[[dict dictionaryValueForKey:@"mzprice"] stringValueForKey:@"oriPrice"]];

    [self GetDateSource:dict];
}


- (void)GetDateSource:(NSDictionary *)dict {
    
    NSString *Str0 = @"已开课";
    NSString *Str2 = [NSString stringWithFormat:@"%@好评",[dict stringValueForKey:@"video_score_rate"]];
    
    _time.text = Str0;
    _good.text = Str2;
    
    NSString *Str3 = [NSString stringWithFormat:@"共%@节",[dict stringValueForKey:@"section_count"]];
    NSString *Str5 = [NSString stringWithFormat:@"%@条",[dict stringValueForKey:@"video_comment_count"]];
    
    _classNum.text = Str3;
    _num.text = Str5;
    
}

@end
