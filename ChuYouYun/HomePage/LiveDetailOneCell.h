//
//  LiveDetailOneCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveDetailOneCell : UITableViewCell

@property (strong ,nonatomic)UIButton *starButton;
@property (strong ,nonatomic)UILabel  *buyPersonNum;

@property (strong ,nonatomic)UILabel  *liveTitle;
@property (strong ,nonatomic)UILabel  *money;
@property (strong ,nonatomic)UILabel  *oldMoney;
@property (strong ,nonatomic)UILabel  *liveDetail;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
