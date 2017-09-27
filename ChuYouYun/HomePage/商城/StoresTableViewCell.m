//
//  StoresTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/12/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "StoresTableViewCell.h"
#import "UIView+Utils.h"


@implementation StoresTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StoresTableViewCell"];
    if (self) {
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
