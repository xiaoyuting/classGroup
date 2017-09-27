//
//  ClassDetailRecommendCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassDetailRecommendCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"



@implementation ClassDetailRecommendCell

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
    _title.text = @"相关推荐";
    _title.textColor = BlackNotColor;
    [self addSubview:_title];
    _title.font = [UIFont boldSystemFontOfSize:18];
//    
//    
//    _name = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,200,20)];
//    _name.font = Font(18);
//    [self addSubview:_name];

}

- (void)dataWithDic:(NSDictionary *)dict {
    
    NSLog(@"%@",dict);
    NSArray *recommendArray = [dict arrayValueForKey:@"recommend_list"];
    
    CGFloat ButtonW = (MainScreenWidth - 3 * SpaceBaside) / 3;
    CGFloat ButtonH = 80;
    
    for (int i = 0 ; i < recommendArray.count ; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i + SpaceBaside / 2 + SpaceBaside * i, 40, ButtonW, ButtonH)];
        
        NSString *urlStr = [[recommendArray objectAtIndex:i] stringValueForKey:@"imageurl"];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        button.tag = i;
        [self addSubview:button];
        if (i == 0) {
            _imageButton1 = button;
        } else if (i == 1) {
            _imageButton2 = button;
        } else if (i == 2) {
            _imageButton3 = button;
        }
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ButtonW * i + SpaceBaside / 2 + SpaceBaside * i, 130, ButtonW, 20)];
        label.text = [[recommendArray objectAtIndex:i] stringValueForKey:@"video_title"];

        label.font = Font(15);
        label.textColor = BlackNotColor;
        [self addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ButtonW * i + SpaceBaside / 2 + SpaceBaside * i, 160, ButtonW, 20)];
        label2.font = Font(13);
        label2.text = [NSString stringWithFormat:@"￥:%@元",[[recommendArray objectAtIndex:i] stringValueForKey:@"t_price"]];
        label2.textColor = [UIColor grayColor];
        [self addSubview:label2];
        
    }

}

- (void)buttonClick:(UIButton *)button {
    
    
}

@end
