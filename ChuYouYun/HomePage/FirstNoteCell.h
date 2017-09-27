//
//  FirstNoteCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *noteDate;
@property (weak, nonatomic) IBOutlet UIButton *forGoodBtn;
@property (weak, nonatomic) IBOutlet UIButton *forCommandBtn;
@property (weak, nonatomic) IBOutlet UILabel *noteCommandLbl;
@property (weak, nonatomic) IBOutlet UILabel *notePraiseLbl;

@end
