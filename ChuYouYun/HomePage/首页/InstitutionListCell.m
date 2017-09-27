//
//  InstitutionListCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionListCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"


@implementation InstitutionListCell


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
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 80, 85)];

    _headImageView.image = Image(@"机构");
    [self addSubview:_headImageView];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, SpaceBaside,MainScreenWidth - 120, 20)];
    [self addSubview:_nameLabel];
    _nameLabel.font = Font(18);
    _nameLabel.text = @"阳光学院";
    
    _personNumber = [[UILabel alloc] initWithFrame:CGRectMake(200, SpaceBaside, 50, 20)];
    [self addSubview:_personNumber];
    _personNumber.textColor = [UIColor grayColor];
    
    _XJButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 35, 80, 12)];
    [_XJButton setBackgroundImage:Image(@"104@2x") forState:UIControlStateNormal];
    [self addSubview:_XJButton];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35,MainScreenWidth - 80, 15)];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"领域：幼儿教育、幼儿中心";
    _titleLabel.font = Font(14);
    _titleLabel.textColor = BlackNotColor;
    _titleLabel.hidden = YES;
    
    //内容
    _contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 55 , MainScreenWidth - 110, 28)];
    [self addSubview:_contentlabel];
    _contentlabel.numberOfLines = 2;
    _contentlabel.textColor = [UIColor grayColor];
    _contentlabel.font = Font(11);
    _contentlabel.text = @"微信公众平台,给个人、企业和组织提供业务服务与用户管理能力的全新服务平台。";
    
    //贴子和成员
    _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 88,MainScreenWidth - 110, 10)];
    [self addSubview:_downLabel];
    _downLabel.textColor = [UIColor grayColor];
    _downLabel.font = Font(11);
    _downLabel.text = @"北京-朝阳区  | 250门课程  | 3000次学习";
    
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.nameLabel.text = text;
    //设置label的最大行数
    self.nameLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];

    self.nameLabel.frame = CGRectMake(100, SpaceBaside, labelSize.size.width, 20);
    if (labelSize.size.width > MainScreenWidth - 150) {
         self.nameLabel.frame = CGRectMake(100, SpaceBaside,MainScreenWidth - 150, 20);
    }
    NSLog(@"%lf",labelSize.size.width);
//    _XJButton.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + SpaceBaside, SpaceBaside + 4, 80, 12);
    _personNumber.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 3, SpaceBaside, 100, 20);
    self.frame = frame;
}

- (void)dataSourceWith:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    
    NSURL *url = [NSURL URLWithString:[dict stringValueForKey:@"logo"]];
    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
    

    if ([dict[@"info"] isEqual:[NSNull null]]) {
        _contentlabel.text = @"";
    } else {
        _contentlabel.text = dict[@"info"];
    }
    [self setIntroductionText:dict[@"title"]];
    _personNumber.text = [NSString stringWithFormat:@"(%@人)",[[dict dictionaryValueForKey:@"count"] stringValueForKey:@"follower_count"]];

    NSString *starStr = [NSString stringWithFormat:@"(%@人)",[[dict dictionaryValueForKey:@"count"] stringValueForKey:@"comment_star"]];
    [_XJButton setBackgroundImage:Image(starStr) forState:UIControlStateNormal];
    
    NSString *locationStr = [dict stringValueForKey:@"location"];
    NSString *videoNumStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"];
    NSString *learnNumStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"learn_count"];
    
    _downLabel.text = [NSString stringWithFormat:@"%@ | %@门课程 | %@次学习",locationStr,videoNumStr,learnNumStr];
 
}

@end
