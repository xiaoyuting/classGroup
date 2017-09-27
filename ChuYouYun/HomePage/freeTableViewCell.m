//
//  freeTableViewCell.m
//  youfuwaiqin
//
//  Created by 我家有福 on 16/4/20.
//  Copyright © 2016年 wojiayoufu. All rights reserved.
//

#import "freeTableViewCell.h"
#import "UIColor+HTMLColors.h"

#define DeviceHight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@implementation freeTableViewCell

- (void)awakeFromNib {
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

-(CGRect)boundingRectWithInitSize:(CGSize)size
{
    
    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect=[self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    
    return rect;
}

- (void)initUI
{
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0,DeviceWidth-30, 120*DeviceHight/667)];
    self.moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(15*DeviceWidth/375, 56*DeviceHight/667, 80*DeviceWidth/375, 36*DeviceHight/667)];
    self.cateGaryLab = [[UILabel alloc]initWithFrame:CGRectMake(120*DeviceWidth/375, 20*DeviceHight/667, 180*DeviceWidth/375, 18*DeviceHight/667)];
    self.firstLab = [[UILabel alloc]initWithFrame:CGRectMake(120*DeviceWidth/375, 48*DeviceHight/667, 180*DeviceWidth/375, 12*DeviceHight/667)];
    self.secondLab = [[UILabel alloc]initWithFrame:CGRectMake(120*DeviceWidth/375, 65*DeviceHight/667, 180*DeviceWidth/375, 12*DeviceHight/667)];
    self.lastLab = [[UILabel alloc]initWithFrame:CGRectMake(120*DeviceWidth/375, 82*DeviceHight/667, 180*DeviceWidth/375, 12*DeviceHight/667)];
    self.moneyLab.font = [UIFont systemFontOfSize:36*DeviceWidth/375];
    self.moneyLab.backgroundColor = [UIColor clearColor];
    self.cateGaryLab.font = [UIFont systemFontOfSize:18*DeviceWidth/375];
    self.cateGaryLab.backgroundColor = [UIColor clearColor];
    self.firstLab.backgroundColor = [UIColor clearColor];
    self.secondLab.backgroundColor = [UIColor clearColor];
    self.lastLab .backgroundColor = [UIColor clearColor];
    self.firstLab.font = [UIFont systemFontOfSize:12*DeviceWidth/375];
    self.secondLab.font = [UIFont systemFontOfSize:12*DeviceWidth/375];
    self.lastLab.font = [UIFont systemFontOfSize:12*DeviceWidth/375];
    NSString *str =  @"¥ 120";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:str];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*DeviceWidth/375]range:[str rangeOfString:@"¥"]];
    self.moneyLab.adjustsFontSizeToFitWidth = YES;
    [self.moneyLab setAttributedText:attrString];
    self.cateGaryLab.text = @"日常保洁劵";
    self.firstLab.text = @"· 此劵只用于日常保洁服务";
    self.secondLab.text = @"· 此劵可抵扣等价福贝值";
    self.lastLab.text = @"· 有效期至2016-12-31";
    
    [self.imageV addSubview:self.moneyLab];
    [self.imageV addSubview:self.cateGaryLab];
    [self.imageV addSubview:self.firstLab];
    [self.imageV addSubview:self.secondLab];
    [self.imageV addSubview:self.lastLab];
    [self addSubview:self.imageV];

    
    
}

//懒加载
-(UILabel *)moneyLab{
    
    if (!_moneyLab) {
        self.moneyLab = [[UILabel alloc]initWithFrame:CGRectZero];
        
    }
    return _moneyLab;
}
- (UILabel *)cateGaryLab{
    if (!_cateGaryLab) {
        self.cateGaryLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _cateGaryLab;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageV;
}

- (UILabel *)firstLab{
    if (!_firstLab) {
        self.firstLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _firstLab;
}


- (UILabel *)secondLab{
    if (!_secondLab) {
        self.secondLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _secondLab;
}
- (UILabel *)lastLab{
    if (!_lastLab) {
        self.lastLab = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _lastLab;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
