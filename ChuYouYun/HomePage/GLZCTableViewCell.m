//
//  GLZCTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/10/17.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLZCTableViewCell.h"
#import "UIView+Utils.h"
#import "UIColor+HTMLColors.h"

@implementation GLZCTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GLZCTableViewCell"];
   
    if (self) {
        
        [self.contentView addSubview:self.mainImagV];
        [self.contentView addSubview:self.mainTitleLab];
        [self.contentView addSubview:self.nextTitleLab];
        [self.contentView addSubview:self.lineLab];
        [self.contentView addSubview:self.firstImagV];
        [self.contentView addSubview:self.firstLab];
        [self.contentView addSubview:self.secondTitleLab];
        [self.contentView addSubview:self.secondImgV];
        [self.contentView addSubview:self.thirdImgV];
        [self.contentView addSubview:self.LastLab];
        [self.contentView addSubview:self.backLab];
        [self.contentView addSubview:self.UseBtn];
    }
    return self;
}

-(UIButton *)UseBtn{
    if (!_UseBtn) {
        _UseBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 90*horizontalrate, 17*horizontalrate, 70*horizontalrate, 20*horizontalrate)];
        _UseBtn.backgroundColor = [UIColor blueColor];
        [_UseBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        [_UseBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_UseBtn.titleLabel setFont:[UIFont systemFontOfSize:14*horizontalrate]];
    }
    return _UseBtn;
    
}
- (void)clickDownload:(UIButton *)sender {
    
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

-(UIImageView *)mainImagV{

    if (!_mainImagV) {
        _mainImagV = [[UIImageView alloc]initWithFrame:CGRectMake(10*horizontalrate, 10*horizontalrate, 108*103/81*MainScreenWidth/375, 103*MainScreenWidth/375)];
        _mainImagV.image = [UIImage imageNamed:@"你好a"];
         _mainImagV.contentMode = UIViewContentModeScaleToFill;
        _mainImagV.backgroundColor = [UIColor cyanColor];

    }
    return _mainImagV;
}

-(UILabel *)mainTitleLab{
    
    if (!_mainTitleLab) {
        _mainTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate,14*horizontalrate, 217*horizontalrate, 14*horizontalrate)];
        _mainTitleLab.font = [UIFont systemFontOfSize:13*horizontalrate];
        _mainTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _mainTitleLab.text = @"最受欢迎公开课";

    }
    return _mainTitleLab;
}

-(UILabel *)nextTitleLab{
    
    if (!_nextTitleLab) {
        _nextTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate, _mainTitleLab.current_y_h+4*horizontalrate, 217*horizontalrate, 16*horizontalrate)];
        _nextTitleLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _nextTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nextTitleLab.text = @"最受欢迎公开课";


    }
    return _nextTitleLab;
}

-(UILabel *)lineLab{
    
    if (!_lineLab) {
        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate, _nextTitleLab.current_y_h+3*horizontalrate, MainScreenWidth - _mainImagV.current_x_w-30*horizontalrate ,1*horizontalrate)];
        _lineLab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _lineLab;
}

-(UIImageView *)firstImagV{
    
    if (!_firstImagV) {
        _firstImagV = [[UIImageView alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate, _lineLab.current_y_h+8*horizontalrate, 12*horizontalrate, 12*horizontalrate)];
        _firstImagV.image = [UIImage imageNamed:@"Like00.png"];
    }
    return _firstImagV;
}

-(UIImageView *)secondImgV{
    
    if (!_secondImgV) {
        _secondImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate, _firstImagV.current_y_h+5*horizontalrate, 12*horizontalrate, 12*horizontalrate)];
        _secondImgV.image = [UIImage imageNamed:@"Like00.png"];

    }
    return _secondImgV;
}

-(UIImageView *)thirdImgV{
    
    if (!_thirdImgV) {
        _thirdImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w+10*horizontalrate, _secondImgV.current_y_h+5*horizontalrate, 12*horizontalrate, 12*horizontalrate)];
        _thirdImgV.image = [UIImage imageNamed:@"Like00.png"];

    }
    return _thirdImgV;
}
-(UILabel *)firstLab{
    
    if (!_firstLab) {
        _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstImagV.current_x_w+3*horizontalrate, _lineLab.current_y_h+8*horizontalrate, MainScreenWidth-_firstImagV.current_x_w-32*horizontalrate, 13*horizontalrate)];
        _firstLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _firstLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _firstLab.text = @"2019.09.12  19:00~21:23";


    }
    return _firstLab;
}
-(UILabel *)secondTitleLab{
    
    if (!_secondTitleLab) {
        _secondTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.current_x,_firstLab.current_y_h+5*horizontalrate,  MainScreenWidth-_firstImagV.current_x_w-32*horizontalrate, 13*horizontalrate)];
        _secondTitleLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _secondTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _secondTitleLab.text = @"报名人数：112345";

    }
    return _secondTitleLab;
}
-(UILabel *)LastLab{
    
    if (!_LastLab) {
        _LastLab = [[UILabel alloc]initWithFrame:CGRectMake(_secondImgV.current_x_w+5*horizontalrate, _secondImgV.current_y_h+5*horizontalrate, MainScreenWidth-_firstImagV.current_x_w-32*horizontalrate, 13*horizontalrate)];
        _LastLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _LastLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _LastLab.text = @"123";

    }
    return _LastLab;
}

-(UILabel *)backLab{
    
    if (!_backLab) {
        _backLab = [[UILabel alloc]initWithFrame:CGRectMake(_mainImagV.current_x_w, _mainImagV.current_y, MainScreenWidth -self.mainImagV.current_x_w -10, _mainImagV.current_h)];
        [self.contentView addSubview:_backLab];
        [_backLab.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
        [_backLab.layer setBorderWidth:1*horizontalrate];
        [_backLab.layer setMasksToBounds:YES];
    }
    NSLog(@"===========%f",_backLab.current_y_h);
    return _backLab;
}
@end
