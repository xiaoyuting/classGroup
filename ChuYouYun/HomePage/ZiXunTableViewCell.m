//
//  ZiXunTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZiXunTableViewCell.h"
#import "SYG.h"


@implementation ZiXunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZiXunTableViewCell"];
    if (self) {
        
        [self.contentView addSubview:self.firstlab];
        [self.contentView addSubview:self.ImagV];
        [self.contentView addSubview:self.ImagV1];
        [self.contentView addSubview:self.ImagV2];

        [self.contentView addSubview:self.secondLab];
//        [self.contentView addSubview:self.lineLab];
        
    }
    return self;
}

-(UILabel *)firstlab{
    
    if (!_firstlab) {
        _firstlab = [[UILabel alloc]initWithFrame:CGRectMake(15,14, MainScreenWidth - 30, 20*MainScreenWidth/320)];
        _firstlab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _firstlab.textColor = [UIColor colorWithHexString:@"#333333"];
        //_firstlab.numberOfLines = 2;
        
        _firstlab.text = @"相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器";
    }
    return _firstlab;
}
-(UIImageView *)ImagV{
    
    if (!_ImagV) {
        
        _ImagV = [[UIImageView alloc]initWithFrame:CGRectMake(15, _firstlab.current_y_h + 3, MainScreenWidth/3 -12, (MainScreenWidth/3 -12)*80/115)];
        _ImagV.image = [UIImage imageNamed:@"你好"];
        
    }
    return _ImagV;
}
-(UIImageView *)ImagV1{
    
    if (!_ImagV1) {
        _ImagV1 = [[UIImageView alloc]initWithFrame:CGRectMake(18 + MainScreenWidth/3 -12, _firstlab.current_y_h + 3, MainScreenWidth/3 -12, (MainScreenWidth/3 -12)*80/115)];
       // _ImagV1.image = [UIImage imageNamed:@"你好"];
        
    }
    return _ImagV1;
}
-(UIImageView *)ImagV2{
    
    if (!_ImagV2) {
        _ImagV2 = [[UIImageView alloc]initWithFrame:CGRectMake(21 + 2*(MainScreenWidth/3 -12), _firstlab.current_y_h + 3, MainScreenWidth/3 -12, (MainScreenWidth/3 -12)*80/115)];
        //_ImagV2.image = [UIImage imageNamed:@"你好"];
    }
    return _ImagV2;
}

-(UILabel *)secondLab{
    
    if (!_secondLab) {
        _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_ImagV.current_y_h + 15, MainScreenWidth - 30, 36*MainScreenWidth/320)];
        _secondLab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _secondLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _secondLab.text = @"剩余并发时间";
        _secondLab.numberOfLines = 2;
    }
    return _secondLab;
}



@end
