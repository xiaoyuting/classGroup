//
//  AskTableViewCell.m
//  ChuYouYun
//
//  Created by IOS on 16/5/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "AskTableViewCell.h"
#import "UIView+Utils.h"
#import "UIColor+HTMLColors.h"


#define DeviceHight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@implementation AskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.aconImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 11,40,40)];
    
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(self.aconImage.current_x_w+10, self.nameLab.current_y, 40,80)];
    
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(100,self.aconImage.current_y,DeviceWidth-110, self.aconImage.current_y)];
    
    self.textLab = [[UILabel alloc]initWithFrame:CGRectMake(self.aconImage.current_x, self.aconImage.current_y_h+10, DeviceWidth-26, 34)];
    
    self.lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-93,self.textLab.current_y_h+20, 80, 15)];
    self.lookBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.lookBtn setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
    
    self.speakBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.lookBtn.current_x-90, self.lookBtn.current_y, 80, 15)];
    
    self.nameLab.font = [UIFont systemFontOfSize:23];
    self.nameLab.backgroundColor = [UIColor clearColor];
    self.timeLab.font = [UIFont systemFontOfSize:11];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textColor = [UIColor colorWithHexString:@"#939393"];
    self.textLab.font = [UIFont systemFontOfSize:17];
    self.textLab.numberOfLines = 2;
    self.timeLab.text = @"2016-12-31";
    
    
    [self.contentView addSubview:self.aconImage];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.textLab];
    [self.contentView addSubview:self.speakBtn];
    [self.contentView addSubview:self.lookBtn];
    
    [self addSubview:self.contentView];
    
    
    
}

//懒加载
-(UILabel *)nameLab{
    
    if (!_nameLab) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        
    }
    return _nameLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _timeLab;
}
- (UIImageView *)aconImage{
    if (!_aconImage) {
        self.aconImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _aconImage;
}


- (UILabel *)textLab{
    if (!_textLab) {
        self.textLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _textLab;
}
- (UIButton *)speakBtn{
    if (!_speakBtn) {
        self.speakBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        self.speakBtn.enabled = NO;
    }
    return _speakBtn;
}

- (UIButton *)lookBtn{
    if (!_lookBtn) {
        self.lookBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        self.lookBtn.enabled = NO;
    }
    return _lookBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
