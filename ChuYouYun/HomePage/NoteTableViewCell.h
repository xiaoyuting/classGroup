//
//  NoteTableViewCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *notehead;
@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UILabel *noteName;
@property (weak, nonatomic) IBOutlet UILabel *noteDate;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UILabel *praiseLbl;
@property (weak, nonatomic) IBOutlet UIButton *commandBtn;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *commandImg;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImg;
@property (weak, nonatomic) IBOutlet UILabel *noBody;

@end
