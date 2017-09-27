//
//  OrderCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "OrderCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"


@implementation OrderCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    //机构图像
    _schoolImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 20, 20)];
    [self addSubview:_schoolImage];
    
    //机构
    _schoolName = [[UILabel alloc] initWithFrame:CGRectMake(40, SpaceBaside, 200, 20)];
    [self addSubview:_schoolName];
    _schoolName.text = @"";
    _schoolName.backgroundColor = [UIColor whiteColor];
    
    //机构按钮
    _schoolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2, 35)];
    _schoolButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_schoolButton];
    
    
    //状态
    _status = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, SpaceBaside, 90, 20)];
    [self addSubview:_status];
    _status.text = @"付款";
    _status.textAlignment = NSTextAlignmentRight;
    _status.backgroundColor = [UIColor whiteColor];
    
    //添加背景色
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, MainScreenWidth, 70)];
    midView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:midView];
    
    
    //图片
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, 40, 60, 60)];
    _headerImage.image = Image(@"你好");
    [self addSubview:_headerImage];
    
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(80,40,MainScreenWidth - 90, 20)];
    [self addSubview:_name];
    _name.text = @"使用一应";
    _name.font = Font(15);
    _name.textColor = BlackNotColor;
    
    //名字
    _content = [[UILabel alloc] initWithFrame:CGRectMake(80, 70,MainScreenWidth - 90, 30)];
    [self addSubview:_content];
    _content.font = Font(12);
    _content.numberOfLines = 2;
    _content.textColor = [UIColor grayColor];
    _content.text = @"你是你上午我问问我我等你过个";
    
    //价格
    _price = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 110,MainScreenWidth - 2 * SpaceBaside, 30)];
    [self addSubview:_price];
    _price.font = Font(14);
    _price.textAlignment = NSTextAlignmentRight;
    _price.textColor = [UIColor grayColor];
    _price.text = @"￥888";
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    
    //取消
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 200, 150, 90, 30)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 3;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.titleLabel.font = Font(16);
    _cancelButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];

    
    //付款
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 150, 90, 30)];
    [_actionButton setTitle:@"付款" forState:UIControlStateNormal];
    _actionButton.layer.cornerRadius = 3;
    _actionButton.layer.borderWidth = 1;
    _actionButton.titleLabel.font = Font(16);
    _actionButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_actionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {
    
    NSLog(@"%@",type);
    NSLog(@"dict ----- %@",dict);
    
    NSString *imageUrl = nil;
//    NSArray *school_info_array = dict[@"source_info"][@"school_info"];
    NSArray *school_info_array = [[dict dictionaryValueForKey:@"source_info"] arrayValueForKey:@"school_info"];
    if (school_info_array.count == 0) {
        
    } else {
//        imageUrl = dict[@"source_info"][@"school_info"][@"logo"];
//        [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
//        _schoolName.text = dict[@"source_info"][@"school_info"][@"title"];
//        
//        NSString *urlStr = dict[@"source_info"][@"cover"];
//        [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
//        
//        _name.text = dict[@"source_info"][@"video_title"];
//        NSString *intro = [self filterHTML:dict[@"source_info"][@"video_intro"]];
//        _content.text = intro;
//        
//        imageUrl = dict[@"source_info"][@"school_info"][@"logo"];
//        [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
//        _schoolName.text = dict[@"source_info"][@"school_info"][@"title"];
        

        
    }
    
    imageUrl = [[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"logo"];
    [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
    _schoolName.text = [[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"];
    
    NSString *urlStr = [[dict dictionaryValueForKey:@"source_info"] stringValueForKey:@"cover"];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _name.text = [[dict dictionaryValueForKey:@"source_info"] stringValueForKey:@"video_title"];
    NSString *intro = [self filterHTML:[[dict dictionaryValueForKey:@"source_info"] stringValueForKey:@"video_intro"]];
    _content.text = intro;

    NSInteger payStatus = [[dict stringValueForKey:@"pay_status"] integerValue];
    if (payStatus == 1) {
        _status.text = @"未支付";
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_actionButton setTitle:@"去支付" forState:UIControlStateNormal];
    } else if (payStatus == 2) {
        _status.text = @"已取消";
        [_cancelButton setTitle:@"" forState:UIControlStateNormal];
        [_actionButton setTitle:@"查看" forState:UIControlStateNormal];
        _cancelButton.hidden = YES;
        _actionButton.enabled = NO;
        _actionButton.backgroundColor = [UIColor grayColor];
        [_actionButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        _actionButton.layer.borderColor = [UIColor grayColor].CGColor;
        
    } else if (payStatus == 3) {
        _status.text = @"已支付";
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"申请退款" forState:UIControlStateNormal];
    } else if (payStatus == 4) {
        _status.text = @"退款审核中";
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
    } else if (payStatus == 5) {
        _status.text = @"退款成功";
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"退款查看" forState:UIControlStateNormal];
    } else if (payStatus == 6) {
        _status.text = @"已驳回";
        _status.textColor = [UIColor redColor];
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"驳回原因" forState:UIControlStateNormal];
        
    }
    _price.text = [NSString stringWithFormat:@"需支付%@",[dict stringValueForKey:@"price"]];
    
    //添加手势
    
    if ([type integerValue] == 4) {
        
    } else {
//        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        
//        [self addGestureRecognizer:longPressGr];
    }

}


#pragma mark ---- 手势

- (void)longPressToDo:(UILongPressGestureRecognizer *)gest {
    
    [MBProgressHUD showSuccess:@"请不要按了" toView:self];
    
    
    
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}





@end
