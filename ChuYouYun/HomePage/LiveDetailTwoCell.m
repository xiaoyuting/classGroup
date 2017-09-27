//
//  LiveDetailTwoCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailTwoCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"


@implementation LiveDetailTwoCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 20, 20)];
    title.font = Font(15);
    title.text = @"讲师介绍：";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:title];
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(title.frame) + SpaceBaside, 60, 60)];
    [self addSubview:_imageButton];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100,CGRectGetMaxY(title.frame), MainScreenWidth - 120, 30)];
    _name.font = Font(20);
    [self addSubview:_name];
    
    _cntent = [[UILabel alloc] initWithFrame:CGRectMake(100,CGRectGetMaxY(_name.frame), MainScreenWidth - 120, 20)];
    _cntent.font = Font(15);
    _cntent.textColor = [UIColor grayColor];
    [self addSubview:_cntent];
    
    _fanNum = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_cntent.frame) + SpaceBaside / 2, MainScreenWidth - 110, 20)];
    _fanNum.textColor = [UIColor grayColor];
    _fanNum.font = Font(15);
    [self addSubview:_fanNum];
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"---讲师%@",dict);
    if (dict.count == 0) {
        return;
    }
    if (dict[@"details"] == nil) {
        self.frame = CGRectMake(0, 0, MainScreenWidth, 40);
        _imageButton.hidden = YES;
        _name.hidden = YES;
        _fanNum.hidden = YES;
        return;
    }
    
    _name.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"name"]];
    _cntent.text = [dict stringValueForKey:@"inro"];
    _fanNum.text  = [NSString stringWithFormat:@"粉丝：%@人",[[[dict dictionaryValueForKey:@"ext_info"] dictionaryValueForKey:@"count_info"] stringValueForKey:@"follower_count"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"headimg"]];
    [_imageButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    self.frame = CGRectMake(0, 0, MainScreenWidth, 120);
    
    
}










@end
