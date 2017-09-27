//
//  MyBuyCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/9.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBuyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cImage;
@property (weak, nonatomic) IBOutlet UIButton *muchBtn;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *Ctext;
@property (weak, nonatomic) IBOutlet UILabel *record;
@property (weak, nonatomic) IBOutlet UIButton *palyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
-(void)starCount:(NSInteger)starCount;
@end
