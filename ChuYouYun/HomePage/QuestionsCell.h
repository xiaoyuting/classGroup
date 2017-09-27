//
//  QuestionsCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIButton *guestBtn;
@property (weak, nonatomic) IBOutlet UILabel *guestName;
@property (weak, nonatomic) IBOutlet UILabel *guests;
@property (weak, nonatomic) IBOutlet UIView *backgoudView;

@end
