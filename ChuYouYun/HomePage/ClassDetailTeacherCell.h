//
//  ClassDetailTeacherCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassDetailTeacherCell : UITableViewCell

@property (strong ,nonatomic)UILabel *bar;
@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UIButton *headerImage;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *content;
@property (strong ,nonatomic)UILabel *fans;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDic:(NSDictionary *)dict;

@end
