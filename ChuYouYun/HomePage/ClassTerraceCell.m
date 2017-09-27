//
//  ClassTerraceCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ClassTerraceCell.h"
#import "SYG.h"


@implementation ClassTerraceCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _bar = [[UILabel alloc] initWithFrame:CGRectMake(5, 10,5, 20)];
    _bar.backgroundColor = BasidColor;
    [self addSubview:_bar];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 20)];
    _title.numberOfLines = 2;
    _title.font = Font(18);
    _title.text = @"平台保障";
    _title.textColor = BlackNotColor;
    _title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_title];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,200,20)];
    _name.font = Font(18);
    [self addSubview:_name];
    
    
    CGFloat ButtonW = MainScreenWidth / 3;
    CGFloat ButtonH = 30;
    
    NSArray *imageArray = @[@"资金安全",@"真实评价",@"实名认证"];
    NSArray *titleArray = @[@"资金安全",@"真实评价",@"实名认证"];
    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonW)];
        if (iPhone5o5Co5S) {
            button.frame = CGRectMake(ButtonW * i, 0, ButtonW, ButtonW);
        } else if (iPhone6) {
//            button.frame = CGRectMake(0, 0, 0, 0);
        } else if (iPhone6Plus) {
//            button.frame = CGRectMake(0, 0, 0, 0);
        }
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [self addSubview:button];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ButtonW * i, ButtonW - 40, ButtonW, ButtonH)];
        if (iPhone5o5Co5S) {
            label.frame = CGRectMake(ButtonW * i, ButtonW - 30, ButtonW, ButtonH);
            label.font = Font(15);
        } else if (iPhone6) {
            //            button.frame = CGRectMake(0, 0, 0, 0);
        } else if (iPhone6Plus) {
            //            button.frame = CGRectMake(0, 0, 0, 0);
        }

        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = BlackNotColor;
        [self addSubview:label];
        
    }
}

- (void)dataWithDic:(NSDictionary *)dict {
    
    
}




@end
