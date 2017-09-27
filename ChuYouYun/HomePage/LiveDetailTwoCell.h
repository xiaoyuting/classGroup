//
//  LiveDetailTwoCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveDetailTwoCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;
@property (strong ,nonatomic)UILabel  *name;
@property (strong ,nonatomic)UILabel  *cntent;
@property (strong ,nonatomic)UILabel  *fanNum;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
