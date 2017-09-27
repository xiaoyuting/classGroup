//
//  GLTeaTableViewCell.m
//  dafengche
//
//  Created by IOS on 17/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GLTeaTableViewCell.h"
#import "SYG.h"

@implementation GLTeaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GLTeaTableViewCell"];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.img];
        [self addSubview:self.nameLab];
        [self addSubview:self.JGLab];
        [self addSubview:self.tagLab1];
        [self addSubview:self.tagLab2];
        [self addSubview:self.tagLab3];
//        [self addSubview:self.tagLab4];
        [self addSubview:self.contentLab];
        [self addSubview:self.areaLab];

    }
    return self;
}


-(UIImageView *)img{

    if (!_img) {
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 100, 100)];
    }
    return _img;
}
-(UILabel *)nameLab{
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 5, 12, 80, 30)];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.font = Font(18);
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}
-(UILabel *)JGLab{
    
    if (!_JGLab) {
        _JGLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 110, 12, 95, 15)];
        _JGLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _JGLab.font = Font(13);
        _JGLab.textAlignment = NSTextAlignmentRight;

    }
    return _JGLab;
}
-(UILabel *)tagLab1{
    
    if (!_tagLab1) {
        _tagLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 5,_nameLab.current_y_h + 3,55, 20)];
        _tagLab1.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _tagLab1.font = Font(13);
        [_tagLab1.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
        [_tagLab1.layer setBorderWidth:0.5];
        [_tagLab1.layer setMasksToBounds:YES];
        _tagLab1.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab1;
}
-(UILabel *)tagLab2{
    
    if (!_tagLab2) {
        _tagLab2 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab1.current_x_w + 10,_nameLab.current_y_h + 3,55, 20)];
        _tagLab2.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _tagLab2.font = Font(13);
        [_tagLab2.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
        [_tagLab2.layer setBorderWidth:0.5];
        [_tagLab2.layer setMasksToBounds:YES];
        _tagLab2.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab2;
}

-(UILabel *)tagLab3{
    
    if (!_tagLab3) {
        _tagLab3 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab2.current_x_w + 5,_nameLab.current_y_h + 3,55, 20)];
        _tagLab3.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _tagLab3.font = Font(13);
        [_tagLab3.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
        [_tagLab3.layer setBorderWidth:0.5];
        [_tagLab3.layer setMasksToBounds:YES];
        _tagLab3.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab3;
}

-(UILabel *)tagLab4{
    
    if (!_tagLab4) {
        _tagLab4 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab3.current_x_w + 5,_nameLab.current_y_h + 3,55, 20)];
        _tagLab4.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _tagLab4.font = Font(13);
        [_tagLab4.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
        [_tagLab4.layer setBorderWidth:0.5];
        [_tagLab4.layer setMasksToBounds:YES];
        _tagLab4.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab4;
}

-(UILabel *)contentLab{
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 5,_tagLab1.current_y_h + 10,MainScreenWidth - _img.current_x_w - 20 , 17)];
        _contentLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _contentLab.font = Font(15);
        _contentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLab;
}

-(UILabel *)areaLab{
    
    if (!_areaLab) {
        _areaLab = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 5,_contentLab.current_y_h + 10,MainScreenWidth - _img.current_x_w - 20, 15)];
        _areaLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _areaLab.font = Font(13);
        _areaLab.textAlignment = NSTextAlignmentRight;
    }
    return _areaLab;
}


@end
