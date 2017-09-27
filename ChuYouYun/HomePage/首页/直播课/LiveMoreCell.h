//
//  LiveMoreCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveMoreCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headImageView;
@property (strong ,nonatomic)UILabel *nameLabel;
@property (strong ,nonatomic)UILabel *timeLabel;
@property (strong ,nonatomic)UILabel *moneyLabel;
@property (strong ,nonatomic)UILabel *moneyAndPersonLabel;
@property (strong ,nonatomic)UIButton *typeButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
