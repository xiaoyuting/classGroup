//
//  SYGBlumTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/22.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "SYGBlumTableViewCell.h"
#import "SYG.h"

@implementation SYGBlumTableViewCell

- (void)awakeFromNib {
    
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    int width;
    if (MainScreenWidth > 375) {
        
        width = 375;
    }else
    {
        width = MainScreenWidth;
    }
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, width / 5 * 2 - 10 + 2, 110 - 26)];
    _imageButton.userInteractionEnabled = NO;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 20, 20)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"mv"] forState:UIControlStateNormal];
    [self.contentView addSubview:_playButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, width - width / 5 * 2 - 13, 14)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _XJButton = [[UIButton alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 13 + 14 + 5 - 2, 80, 12)];
    [self.contentView addSubview:_XJButton];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 42 + 2, MainScreenWidth - width / 5 * 2 - 13 - 10, 30 + 5)];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    
    _KSButton = [[UIButton alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, CGRectGetMaxY(_contentLabel.frame) + 2, 15,15)];
    [_KSButton setBackgroundImage:[UIImage imageNamed:@"clockSYG.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_KSButton];
    
    _KSLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13 + 25, CGRectGetMaxY(_contentLabel.frame) + 2, 40, 15)];
    _KSLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_KSLabel];
    
    _XBLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13 + 25 + 66 - 10, CGRectGetMaxY(_contentLabel.frame) + 2, 200, 15)];
    _XBLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_XBLabel];
    
}
- (void)setVlaues:(NSDictionary *)dict
{
    _titleLabel.text = [dict objectForKey:@"title"];
}

@end
