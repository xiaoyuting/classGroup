//
//  WZTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/12/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "WZTableViewCell.h"
#import "SYG.h"


@implementation WZTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WZTableViewCell"];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.ImagV];
        [self addSubview:self.firstLab];
        [self addSubview:self.secondlab];
        [self addSubview:self.lineLab];
        
    }
    return self;
}

-(UIImageView *)ImagV{
    
    if (!_ImagV) {
        
        _ImagV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,50, 50)];
    }
    return _ImagV;
}

-(UILabel *)firstLab{
    
    if (!_firstLab) {
        _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 10, 15,MainScreenWidth - 70, 30)];
        _firstLab.font = [UIFont systemFontOfSize:13];
        _firstLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _firstLab.text = @"综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分综合：4.5分";
        _firstLab.numberOfLines = 2;
    }
    return _firstLab;
}

-(UILabel *)secondlab{
    
    if (!_secondlab) {
        
        _secondlab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 10,_firstLab.current_y_h, MainScreenWidth - 70, 15)];
        _secondlab.font = [UIFont systemFontOfSize:12];
        _secondlab.textColor = [UIColor grayColor];
        _secondlab.text = @"开始开始开始开始开始开始开始开始开始开始开始开始开始开始开始开始时间";
    }
    return _secondlab;
}

-(UILabel *)lineLab{
    
    if (!_lineLab) {
        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0,67, MainScreenWidth, 3)];
        _lineLab.backgroundColor = [UIColor whiteColor];
    }
    return _lineLab;
}


@end
