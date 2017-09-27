//
//  SYGXQTeacherTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/1.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "SYGXQTeacherTableViewCell.h"

@implementation SYGXQTeacherTableViewCell

- (void)awakeFromNib {
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
    //头像
    _HeadImage = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    [self addSubview:_HeadImage];
    
    //名字
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 16 + 9, 200, 20)];
    [self addSubview:_NameLabel];
    
    //介绍
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, MainScreenWidth - 20, 100)];
    _JTLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_JTLabel];
    

    
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(MainScreenWidth - 20, 1000);
    
    CGSize labelSize = [self.JTLabel.text sizeWithFont:self.JTLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应的高度
    frame.size.height = labelSize.height + 50 + 10 + 20;

    
    self.frame = frame;
}




@end
