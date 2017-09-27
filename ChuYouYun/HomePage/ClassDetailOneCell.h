//
//  ClassDetailOneCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassDetailOneCell : UITableViewCell

@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UILabel *price;
@property (strong ,nonatomic)UILabel *ordPrice;
@property (strong ,nonatomic)UILabel *line;

@property (strong ,nonatomic)UILabel *time;
@property (strong ,nonatomic)UILabel *good;

@property (strong ,nonatomic)UILabel *classNum;
@property (strong ,nonatomic)UILabel *iphone;
@property (strong ,nonatomic)UILabel *num;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDic:(NSDictionary *)dict;
- (void)schoolInfo:(NSDictionary *)dict;
@end
