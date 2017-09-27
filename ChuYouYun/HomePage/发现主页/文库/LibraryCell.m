//
//  LibraryCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LibraryCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"



@implementation LibraryCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 78, 85)];
    _headImageView.image = Image(@"文档图标");
    [self addSubview:_headImageView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, SpaceBaside,MainScreenWidth - 2 * SpaceBaside - CGRectGetWidth(_headImageView.frame) - SpaceBaside, 20)];
    _titleLabel.text = @"2014物业管理师考试参考答案";
    _titleLabel.font = Font(16);
    _titleLabel.textColor = BlackNotColor;
    [self addSubview:_titleLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 35, MainScreenWidth - 2 * SpaceBaside, 15)];
    [self addSubview:_timeLabel];
    _timeLabel.text = @"更新时间：2016-10-10";
    _timeLabel.font = Font(12);
    _timeLabel.textColor = [UIColor grayColor];
    
    //文件大小
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 50, MainScreenWidth - 2 * SpaceBaside, 15)];
    [self addSubview:_sizeLabel];
    _sizeLabel.text = @"文件大小：3M";
    _sizeLabel.textColor = [UIColor grayColor];
    _sizeLabel.font = Font(12);
    
    //文件类型
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 65,MainScreenWidth - 80, 15)];
    [self addSubview:_typeLabel];
    _typeLabel.text = @"文件格式：pdf";
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = Font(12);

    //下载次数
    _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 80,MainScreenWidth - 80, 15)];
    [self addSubview:_downLabel];
    _downLabel.font = Font(12);
    _downLabel.text = @"下载次数：99";
    _downLabel.textColor = [UIColor grayColor];
    
    //下载按钮
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 65, 90, 30)];
    [_downButton setTitle:@"下载" forState:UIControlStateNormal];
    _downButton.titleLabel.font = Font(15);
    [_downButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _downButton.layer.borderWidth = 1;
    _downButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:_downButton];
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    
    _titleLabel.text = [dict stringValueForKey:@"title"];
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    _timeLabel.text = [NSString stringWithFormat:@"更新时间：%@",timeStr];
    _downLabel.text = [NSString stringWithFormat:@"兑换次数：%@",[dict stringValueForKey:@"axchange_num"]];
    
    NSString *typeStr = [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"extension"];
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//购买的

        _typeLabel.text = [NSString stringWithFormat:@"文件格式：%@",typeStr];
        [_downButton setTitle:@"下载" forState:UIControlStateNormal];
        
    } else {
        [_downButton setTitle:@"兑换" forState:UIControlStateNormal];
        _typeLabel.text = [NSString stringWithFormat:@"需要积分：%@",[dict stringValueForKey:@"price"]];
    }
    _sizeLabel.text = [NSString stringWithFormat:@"文件大小：%@", [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"size"]];
    
    NSString *urlStr = dict[@"cover"];
    
    if ([urlStr isEqualToString:@""]) {//没有图片
        if ([typeStr isEqualToString:@"ppt"] || [typeStr isEqualToString:@"pptx"]) {
            _headImageView.image = Image(@"ppt");
        } else if ([typeStr isEqualToString:@"excel"]) {
            _headImageView.image = Image(@"excel");
        } else if ([typeStr isEqualToString:@"pdf"]) {
            _headImageView.image = Image(@"pdf");
        } else if ([typeStr isEqualToString:@"word"]) {
            _headImageView.image = Image(@"word");
        } else if ([typeStr isEqualToString:@"txt"]) {
           _headImageView.image = Image(@"txt");
        } else if ([typeStr isEqualToString:@"docx"]) {
           _headImageView.image = Image(@"word");
        }
        
    } else {//有图片
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        
    }
    

    
    
    
}


@end
