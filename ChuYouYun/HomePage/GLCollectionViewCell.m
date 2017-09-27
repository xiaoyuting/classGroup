//
//  GLCollectionViewCell.m
//  dafengche
//
//  Created by IOS on 17/1/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GLCollectionViewCell.h"
#import "SYG.h"

@implementation GLCollectionViewCell

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
    _newsTVC.view.frame = self.bounds;
    _newsTVC.urlString = urlString;
    [self addSubview:_newsTVC.view];
}

@end
