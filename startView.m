//
//  startView.m
//  FavouriteFree
//
//  Created by qianfeng on 14-10-21.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "startView.h"
#import "Helper.h"
@implementation startView

-(void)createContent
{

    backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 23)];
    backgroundView.image = [Helper imageNamed:@"star031" cache:YES];
    backgroundView.contentMode = UIViewContentModeBottomLeft;
    
    foregroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 23)];
    foregroundView.image = [Helper imageNamed:@"star021" cache:YES];
    foregroundView.contentMode = UIViewContentModeBottomLeft;//对齐方式
    foregroundView.clipsToBounds = YES;//裁剪属性
    
    [self addSubview:backgroundView];
    [self addSubview:foregroundView];
    self.backgroundColor = [UIColor clearColor];
}
//此方法给xib使用（xib使用时自动调用）
-(id)initWithCoder:(NSCoder *)aDecoder
{
    //这里必须调用[super initWithCoder:aDecoder]
    if (self = [super initWithCoder:aDecoder]) {
        [self createContent];
    }
    return self;
}
-(void)setStar:(CGFloat)star
{
    CGRect  frame = backgroundView.frame;
    //根据星级计算图片星星的宽度
    frame.size.width = frame.size.width*(star/5);
    foregroundView.frame = frame;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createContent];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
