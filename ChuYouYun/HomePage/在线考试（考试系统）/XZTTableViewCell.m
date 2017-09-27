//
//  XZTTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "XZTTableViewCell.h"
#import "SYG.h"

@implementation XZTTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _XZButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
//    _XZButton.layer.cornerRadius = 10;
    [self addSubview:_XZButton];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, MainScreenWidth - 70, 10)];
    _contentLabel.font = Font(18);
    _contentLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [self addSubview:_contentLabel];

}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.contentLabel.text = text;
    //设置label的最大行数
    self.contentLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, MainScreenWidth - 70, labelSize.size.height);
    frame.size.height = labelSize.size.height + 20 ;
    
    _XZButton.center = CGPointMake(20, (labelSize.size.height + 20 + 15) / 2 );
    
    self.frame = frame;
}



@end
