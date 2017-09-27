//
//  GLImageVievs.m
//  dafengche
//
//  Created by IOS on 16/11/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLImageVievs.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SYG.h"

@interface GLImageVievs (){
    
    NSArray *_urls;
    NSArray *_titleArr;
}

@end

@implementation GLImageVievs

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array titleArr:(NSArray *)titleArr{

    if (self = [super initWithFrame:frame]) {
;
        _urls = [NSArray arrayWithArray:array];
        _titleArr = titleArr;
        
         [self initUI];
    }
    return self;
}

- (void)initUI
{
    //self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    // 1.创建9个UIImageView
    UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
    CGFloat width = MainScreenWidth/3 - 50/3;
    CGFloat height = width*160/277;
    CGFloat margin = 10;
    CGFloat startX = 15;
    CGFloat startY = 0;
    if (_urls.count==0) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30,self.frame.size.width, 30)];
        lab.text = @"暂时没有图片";
        lab.textColor = [UIColor grayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        [self addSubview:lab];
        return;
    }
    for (int i = 0; i<_urls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        
        // 计算位置
        int row = i/3;
        int column = i%3;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin*3 - 5);
        imageView.frame = CGRectMake(x, y, width, height);
        
        // 下载图片
        [imageView setImageURLStr:_urls[i] placeholder:placeholder];
        
        // 事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //标题
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(imageView.current_x, imageView.current_y_h,width, 15)];
        lab.text = [NSString stringWithFormat:@"%@",_titleArr[i]];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        UIColor *color = [UIColor blackColor];
        lab.backgroundColor = [color colorWithAlphaComponent:0.2];
        [self addSubview:lab];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = (int)_urls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
