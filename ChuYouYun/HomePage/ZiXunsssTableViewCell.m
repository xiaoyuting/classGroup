//
//  ZiXunsssTableViewCell.m
//  dafengche
//
//  Created by IOS on 17/2/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZiXunsssTableViewCell.h"
#import "SYG.h"

@implementation ZiXunsssTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZiXunsssTableViewCell"];
    if (self) {
        
        [self.contentView addSubview:self.firstlab];
        [self.contentView addSubview:self.ImagV];
        [self.contentView addSubview:self.secondLab];
        //        [self.contentView addSubview:self.lineLab];
        
    }
    return self;
}

-(UILabel *)firstlab{
    
    if (!_firstlab) {
        _firstlab = [[UILabel alloc]initWithFrame:CGRectMake(15,17, MainScreenWidth*2/3 - 10, 15*MainScreenWidth/320)];
        _firstlab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _firstlab.textColor = [UIColor colorWithHexString:@"#333333"];
        //_firstlab.numberOfLines = 2;
        
        _firstlab.text = @"相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器";
    }
    return _firstlab;
}
-(UIImageView *)ImagV{
    
    if (!_ImagV) {
        
        _ImagV = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth*2/3, _firstlab.current_y - 3, MainScreenWidth/3 -12, (MainScreenWidth/3 -12)*80/115)];
        _ImagV.image = [UIImage imageNamed:@"你好"];
        
    }
    return _ImagV;
}

-(UILabel *)secondLab{
    
    if (!_secondLab) {
        _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_firstlab.current_y_h + 5, MainScreenWidth*2/3 - 10 - 10, 36*MainScreenWidth/320)];
        _secondLab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _secondLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _secondLab.text = @"剩余并发时间";
        _secondLab.numberOfLines = 2;
    }
    return _secondLab;
}

@end
