//
//  ClassContentCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassContentCell.h"
#import "SYG.h"

@implementation ClassContentCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    //内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 50)];
    _contentLabel.font = [UIFont systemFontOfSize:15];
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
    
    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);

    frame.size.height = labelSize.size.height + 20 ;

    self.frame = frame;
}


@end
