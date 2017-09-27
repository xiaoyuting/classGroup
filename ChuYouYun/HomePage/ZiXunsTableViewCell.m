//
//  ZiXunsTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/11/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZiXunsTableViewCell.h"
#import "SYG.h"


@implementation ZiXunsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZiXunsTableViewCell"];
    if (self) {
        
        [self.contentView addSubview:self.firstlab];
        [self.contentView addSubview:self.secondLab];
        
    }
    return self;
}

-(UILabel *)firstlab{
    
    if (!_firstlab) {
        _firstlab = [[UILabel alloc]initWithFrame:CGRectMake(15,14, MainScreenWidth - 30, 20*MainScreenWidth/320)];
        _firstlab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _firstlab.textColor = [UIColor colorWithHexString:@"#333333"];
        
        _firstlab.text = @"相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器相当器";
    }
    return _firstlab;
}


-(UILabel *)secondLab{
    
    if (!_secondLab) {
        _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_firstlab.current_y_h + 5, MainScreenWidth - 30, 36*MainScreenWidth/320)];
        _secondLab.font = [UIFont systemFontOfSize:12*MainScreenWidth/320];
        _secondLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _secondLab.text = @"剩余并发时间";
        _secondLab.numberOfLines = 2;

    }
    return _secondLab;
}


@end
