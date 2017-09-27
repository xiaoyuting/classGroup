//
//  InstatutionCollectionViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/24.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstatutionCollectionViewCell.h"
#import "UIView+Utils.h"
#import "SYG.h"


@implementation InstatutionCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
//        [self addSubview:self.imageV];
//        [self addSubview:self.title];
//        [self addSubview:self.icon];
        [self addSubview];
    }
    return self;
}
//懒加载
//- (UIImageView *)imageV
//{
//    if (!_imageV) {
//        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,_frame.size.width-10,(_frame.size.width-10)*1.4)];
//    }
//    return _imageV;
//}
//- (UILabel *)title{
//    if (!_title) {
//        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,_imageV.current_y_h+10, _frame.size.width, 18)];
//        self.title.font = [UIFont systemFontOfSize:15];
//        self.title.textAlignment = NSTextAlignmentCenter;
//    }
//    return _title;
//}
//- (UILabel *)icon{
//    if (!_price) {
//        self.price = [[UILabel alloc]initWithFrame:CGRectMake(0, _title.current_y_h+5, _frame.size.width, 18)];
//        self.price.font = [UIFont systemFontOfSize:13];
//        self.price.textColor = [UIColor lightGrayColor];
//        self.price.numberOfLines = 2;
//        self.price.textAlignment = NSTextAlignmentCenter;
//        
//    }
//    return _price;
//}


- (void)addSubview {
    
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    _imageV.image = Image(@"你好");
    [self addSubview:_imageV];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_imageV.frame),self.bounds.size.width , 40)];
    _title.numberOfLines = 2;
    _title.text = @"适应自然法则";
    [self addSubview:_title];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_title.frame), self.bounds.size.width, 40)];
    _price.text = @"￥122";
    _price.textColor = [UIColor redColor];
    [self addSubview:_price];
    
}

@end
