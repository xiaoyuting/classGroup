//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionViewHeaderView.h"
#import "SYG.h"

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside / 2 , SpaceBaside, MainScreenWidth - 100, 30)];
        self.title.font = Font(15);
        self.title.textColor = [UIColor grayColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.title];
    }
    return self;
}

@end
