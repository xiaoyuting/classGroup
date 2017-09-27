//
//  ClassContentCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassContentCell : UITableViewCell

@property (strong ,nonatomic)UILabel *contentLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

@end
