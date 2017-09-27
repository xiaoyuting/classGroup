//
//  WDTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/16.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "WDTableViewCell.h"

@implementation WDTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 2;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //添加整个VIew
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MainScreenWidth, 400)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    _backView = backView;
    _backView.layer.borderColor = [UIColor clearColor].CGColor;
    _backView.layer.borderWidth = 0;

    //头像
    _HeadImage = [[UIButton alloc] initWithFrame:CGRectMake(14, 11, 40, 40)];
    [_HeadImage setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [backView addSubview:_HeadImage];
    
    //名字
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 21, 200, 20)];
    [backView addSubview:_NameLabel];
    
    //时间
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, 21, 80, 20)];
    _TimeLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _TimeLabel.font = [UIFont systemFontOfSize:11];
    _TimeLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_TimeLabel];
    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, MainScreenWidth - 20, 100)];
    _JTLabel.font = [UIFont systemFontOfSize:17];
    [backView addSubview:_JTLabel];

    
    //图片
    _TPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    //观看的图片
    UIButton *GKButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth -70 , 0, 20, 10)];
    [GKButton setBackgroundImage:[UIImage imageNamed:@"观看@2x"] forState:UIControlStateNormal];
    [self addSubview:GKButton];
    _GKButton = GKButton;
    
    //观看人数
    _GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(GKButton.frame.origin.x+GKButton.frame.size.width+2, 0, 40, 20)];
    _GKLabel.font = [UIFont systemFontOfSize:14];
    _GKLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _GKLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_GKLabel];

    //评论人数
    _PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 118, 0, 30, 20)];
    _PLLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _PLLabel.textAlignment = NSTextAlignmentLeft;
    _PLLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:_PLLabel];
    
    //评论图片
    UIButton *PLButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 , 0, 20, 20)];
    [PLButton setBackgroundImage:[UIImage imageNamed:@"问答评论评论@2x"] forState:UIControlStateNormal];
    [backView addSubview:PLButton];
    _PLButton = PLButton;
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 2;
    CGSize size = CGSizeMake(MainScreenWidth - 20, 80);//(MainScreenWidth - 20, 1000) 这样的话为自适应
    
    CGSize labelSize = [self.JTLabel.text sizeWithFont:self.JTLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应的高度
//    
    NSLog(@"%lf",labelSize.height);
    
    //这里解决了点击的时候出现横线的bug
    if (labelSize.height > 30) {
         frame.size.height = labelSize.height + 50 + 10 + 10 + 3;
    } else {
         frame.size.height = 20 + 50 + 10 + 10 + 3;
    }
//    frame.size.height = labelSize.height + 50 + 10 + 10 + 3;
    
    //初步确定图片试图的大小
    _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame) + 10, MainScreenWidth, 0);
    
//    _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame), 0, 0);
    _PLButton.frame = CGRectMake(MainScreenWidth - 150, CGRectGetMaxY(_JTLabel.frame) + 5 + 3, 17, 17);
    _GKButton.frame = CGRectMake(MainScreenWidth - 80, CGRectGetMaxY(_JTLabel.frame) + 5 + 5 + 4, 20, 14);
    _PLLabel.frame = CGRectMake(MainScreenWidth - 130, CGRectGetMaxY(_JTLabel.frame) + 5, 30, 20);
    _GKLabel.frame = CGRectMake(MainScreenWidth - 58, CGRectGetMaxY(_JTLabel.frame) + 5, 55, 20);

    _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_GKLabel.frame) + 10);

    self.frame = frame;
    
}

- (void)imageWithArray:(NSArray *)array {
    CGFloat Space = 10;
    CGFloat JJ = 14;
    CGFloat BWirth = (MainScreenWidth - (2 * Space) - 2 * JJ) / 3;

    if (array == nil) {//如果数组为空，说明图片试图的尺寸为0
        _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame), 0, 0);
        _PLButton.frame = CGRectMake(MainScreenWidth - 140, CGRectGetMaxY(_JTLabel.frame), 20, 20);
        _GKButton.frame = CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_JTLabel.frame), 20, 20);
        _PLLabel.frame = CGRectMake(MainScreenWidth - 120, CGRectGetMaxY(_JTLabel.frame), 30, 20);
        _GKLabel.frame = CGRectMake(MainScreenWidth - 50, CGRectGetMaxY(_JTLabel.frame), 35, 20);
        
    }else {
        //这个的图片是正方形
        for (int i = 0 ; i < array.count ; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(JJ + (i % 3) * BWirth + (i % 3) * Space, Space + (i / 3) * BWirth + (i / 3) * Space, BWirth, BWirth)];
            [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            [_TPView addSubview:button];
            
            //图片试图的大小
            _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame), MainScreenWidth, CGRectGetMaxY(button.frame));
            
            
            //确定点赞和评论的位置
            _PLButton.frame = CGRectMake(MainScreenWidth - 140, CGRectGetMaxY(_TPView.frame), 20, 20);
            _GKButton.frame = CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_TPView.frame), 20, 20);
            _PLLabel.frame = CGRectMake(MainScreenWidth - 120, CGRectGetMaxY(_TPView.frame), 30, 20);
            _GKLabel.frame = CGRectMake(MainScreenWidth - 48, CGRectGetMaxY(_TPView.frame), 35, 20);

            
            //确定backView的大小
            _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_GKLabel.frame));
            self.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_backView.frame));
            
        }

    }
    
    //cell的具体可以根据点赞和评论的位置来定
    
    
    
}


@end
