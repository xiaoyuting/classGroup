//
//  LibCateCollectionViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LibCateCollectionViewCell.h"
#import "SYG.h"


@implementation LibCateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview];
    }
    return self;
}

- (void)addSubview {

    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside,self.bounds.size.width , 20)];
    _title.text = @"动物世界";
    _title.font = Font(14);
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];

    
}

@end
