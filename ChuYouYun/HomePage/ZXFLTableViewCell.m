//
//  ZXFLTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZXFLTableViewCell.h"

@implementation ZXFLTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
    [self addSubview:_imageButton];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
    [self addSubview:_NameLabel];
    
}



@end
