//
//  LiveDetailFourCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailFourCell.h"
#import "SYG.h"


@implementation LiveDetailFourCell

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
    title.text = @"上课须知";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:title];

}



@end
