//
//  BigWindCar_CommentCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigWindCar_CommentCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;
@property (strong ,nonatomic)UILabel *score;
@property (strong ,nonatomic)UILabel *comment;
@property (strong ,nonatomic)UILabel *name;



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
