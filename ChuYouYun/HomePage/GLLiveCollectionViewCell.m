//
//  GLLiveCollectionViewCell.m
//  dafengche
//
//  Created by IOS on 17/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GLLiveCollectionViewCell.h"
#import "UIView+Utils.h"
#import "DDNewsTVC.h"


@implementation GLLiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, MainScreenWidth - 40, 30)];
        [self addSubview:lab];
        lab.backgroundColor = [UIColor redColor];
        //		NSLog(@"%s", __func__);
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    _newsTVC = [[DDNewsTVC alloc]init];

    _newsTVC.view.frame = CGRectMake(0, 20, MainScreenWidth, self.frame.size.height - 30);
    _newsTVC.urlString = urlString;
    [self addSubview:_newsTVC.view];
}



@end
