//
//  ClassDetailTeacherCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassDetailTeacherCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"



@implementation ClassDetailTeacherCell

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
    _title.text = @"老师介绍";
    _title.textColor = BlackNotColor;
    [self addSubview:_title];
    _title.font = [UIFont boldSystemFontOfSize:18];
    
    _headerImage = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 80, 80)];
    _headerImage.backgroundColor = [UIColor whiteColor];
    [_headerImage setBackgroundImage:Image(@"站位图") forState:UIControlStateNormal];
    [self addSubview:_headerImage];
    _headerImage.userInteractionEnabled = YES;
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,200,20)];
    _name.font = Font(18);
    [self addSubview:_name];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(100, 70,MainScreenWidth - 110,30)];
    _content.font = Font(16);
    _content.textColor = [UIColor grayColor];
    _content.text = @"这是个高级教师哦";
    [self addSubview:_content];
    
    UIButton *fanButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 110, 20, 20)];
    [fanButton setBackgroundImage:Image(@"详情粉丝") forState:UIControlStateNormal];
    [self addSubview:fanButton];
    
    _fans= [[UILabel alloc] initWithFrame:CGRectMake(130, 110, MainScreenWidth - 140, 20)];
    _fans.textColor = [UIColor grayColor];
    _fans.text = @"粉丝：110人";
    [self addSubview:_fans];

}

- (void)dataWithDic:(NSDictionary *)dict {

    NSLog(@"%@",dict);
    if (dict.count == 0) {
        return;
    }
    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"headimg"]] forState:UIControlStateNormal];
    _headerImage.layer.cornerRadius = 40;
    _headerImage.layer.masksToBounds = YES;
    _name.text = [dict stringValueForKey:@"name"];
    _content.text = [dict stringValueForKey:@"teach_evaluation"];
    _fans.text = [NSString stringWithFormat:@"粉丝：%@人",[[[dict dictionaryValueForKey:@"ext_info"] dictionaryValueForKey:@"count_info"] stringValueForKey:@"follower_count"]];
}



@end
