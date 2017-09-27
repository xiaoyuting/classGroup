//
//  TagsCell.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/25.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "TagsCell.h"

@implementation TagsCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)isSelect:(BOOL)isClick
{
    if (isClick == YES) {
        [self.select setImage:[UIImage imageNamed:@"check .png"]];
    }else if(isClick == NO)
    {
        [self.select setImage:[UIImage imageNamed:@"check 拷贝.png"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
