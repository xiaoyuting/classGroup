//
//  CourseCell.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "CourseCell.h"

@implementation CourseCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)starCount:(NSInteger)starCount
{
    switch (starCount) {
        case 1:
            [self.star1 setImage:[UIImage imageNamed:@"star00.png"]];
            break;
        case 2:
            [self.star1 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star2 setImage:[UIImage imageNamed:@"star00.png"]];
            break;
        case 3:
            [self.star1 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star2 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star3 setImage:[UIImage imageNamed:@"star00.png"]];
            break;
        case 4:
            [self.star1 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star2 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star3 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star4 setImage:[UIImage imageNamed:@"star00.png"]];
            break;
        case 5:
            [self.star1 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star2 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star3 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star4 setImage:[UIImage imageNamed:@"star00.png"]];
            [self.star5 setImage:[UIImage imageNamed:@"star00.png"]];
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
