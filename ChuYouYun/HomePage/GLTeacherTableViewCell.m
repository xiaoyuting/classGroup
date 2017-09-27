//
//  GLTeacherTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/11/21.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLTeacherTableViewCell.h"
#import "SYG.h"


@implementation GLTeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _ImagV.layer.cornerRadius = 20;
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GLTeacherTableViewCell"];
    if (self) {
        [self addSubview:self.ImagV];
        [self addSubview:self.firstLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.Starbtn];
        [self addSubview:self.secondlab];
        [self addSubview:self.lastLab];
        [self addSubview:self.namelab];
        [self addSubview:self.lineLab];
    }
    return self;
}

-(UIImageView *)ImagV{
    
    if (!_ImagV) {
        
        _ImagV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 40*MainScreenWidth/320, 40*MainScreenWidth/320)];
//        _ImagV.image = [UIImage imageNamed:@"你好"];
        _ImagV.layer.cornerRadius = 20*MainScreenWidth/320;
        _ImagV.layer.masksToBounds = true;
        _ImagV.backgroundColor = [UIColor cyanColor];
    }
    return _ImagV;
}

-(UILabel *)firstLab{
    
    if (!_firstLab) {
        _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 15, 10,43, 15)];
        _firstLab.font = [UIFont systemFontOfSize:14];
        _firstLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _firstLab.text = @"评分：";
    }
    return _firstLab;
}

-(UILabel *)timeLab{
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 220, 10,185, 15*MainScreenWidth/320)];
        _timeLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _timeLab.textColor = [UIColor grayColor];
        _timeLab.text = @"01月13日 13：56";
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

-(UIButton *)Starbtn{

    if (!_Starbtn) {
        _Starbtn = [[UIButton alloc]initWithFrame:CGRectMake(_firstLab.current_x_w,10,80,15)];
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    return _Starbtn;
}
-(UILabel *)secondlab{
    
    if (!_secondlab) {
        _secondlab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 15, _firstLab.current_y_h+10, MainScreenWidth - 50 - _ImagV.current_x_w, 20)];
        _secondlab.font = [UIFont systemFontOfSize:12];
        _secondlab.textColor = [UIColor blackColor];
        _secondlab.text = @"";
    }
    return _secondlab;
}

-(UILabel *)lastLab{
    
    if (!_lastLab) {
        
        _lastLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 15, _secondlab.current_y_h+3, MainScreenWidth - 50 - _ImagV.current_x_w, 20)];
        _lastLab.font = [UIFont systemFontOfSize:12];
        _lastLab.textColor = [UIColor blackColor];
        _lastLab.text = @"";
    }
    return _lastLab;
}

-(UILabel *)namelab{
    
    if (!_namelab) {
        _namelab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x, _ImagV.current_y_h +3, 40*MainScreenWidth/320+1, 15*MainScreenWidth/320)];
        _namelab.font = [UIFont systemFontOfSize:9*MainScreenWidth/320];
        _namelab.textColor = [UIColor colorWithHexString:@"#333333"];
        _namelab.text = @"";
        _namelab.textAlignment = NSTextAlignmentCenter;
    }
    return _namelab;
}

-(UILabel *)lineLab{
    
    if (!_lineLab) {
        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.current_x,_namelab.current_y_h+3, MainScreenWidth - 50 - _ImagV.current_x_w, 1)];
        _lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineLab;
}

@end
