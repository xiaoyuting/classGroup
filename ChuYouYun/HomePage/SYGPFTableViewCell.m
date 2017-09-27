//
//  SYGPFTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/1.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGPFTableViewCell.h"

@implementation SYGPFTableViewCell

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
    //介绍
    _PFLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 60, 20)];
    _PFLabel.font = [UIFont systemFontOfSize:14];
    _PFLabel.text = @"评  分:";
    _PFLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_PFLabel];
    
    //评分
    _PFButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 17.5, 80, 15)];
    [self addSubview:_PFButton];
    

    _XXRSLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 2, 15, 70, 20)];
    _XXRSLabel.font = [UIFont systemFontOfSize:14];
    _XXRSLabel.text = @"学习人数:";
    [self addSubview:_XXRSLabel];
    
    _Number = [[UILabel alloc] initWithFrame:CGRectMake(width / 2 + 70, 15, 60, 20)];
    _Number.font = [UIFont systemFontOfSize:14];
    [self addSubview:_Number];
}

@end
