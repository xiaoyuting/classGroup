//
//  mainCollectionViewCell.m
//  寒假项目
//
//  Created by GLTom on 16/2/2.
//  Copyright © 2016年 GLTom. All rights reserved.
//

#import "mainCollectionViewCell.h"
#import "UIView+Utils.h"

@implementation mainCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        [self addSubview:self.imageV];
        [self addSubview:self.title];
        [self addSubview:self.icon];
    }
    return self;
}
//懒加载
- (UIImageView *)imageV
{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10,_frame.size.width-10,(_frame.size.width-10)*1)];
    }
    return _imageV;
}
- (UILabel *)title{
    if (!_title) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,_imageV.current_y_h+10, _frame.size.width, 18)];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
- (UILabel *)icon{
    if (!_icon) {
        self.icon = [[UILabel alloc]initWithFrame:CGRectMake(0, _title.current_y_h+5, _frame.size.width, 18)];
        self.icon.font = [UIFont systemFontOfSize:13];
        self.icon.textColor = [UIColor lightGrayColor];
        self.icon.numberOfLines = 2;
        self.icon.textAlignment = NSTextAlignmentCenter;

    }
    return _icon;
}
@end
