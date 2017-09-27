//
//  LibCateCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LibCateCell.h"
#import "SYG.h"

@implementation LibCateCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside,100, 30)];
    _title.text = @"高中屋里";
    _title.font = Font(16);
    _title.textColor = BlackNotColor;

    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    _title.text = dict[@"title"];
    
}

- (void)arrayWithArray:(NSArray *)array withIndex:(NSInteger)index; {
    
    if ([array[index] integerValue] == 0) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.title.textColor = BlackNotColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.title.textColor = BasidColor;
    }
    
}



@end
