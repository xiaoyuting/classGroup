//
//  classDetailZeroCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface classDetailZeroCell : UITableViewCell

@property (strong,nonatomic)UILabel *score;
@property (strong ,nonatomic)UIButton *starButton;
@property (strong ,nonatomic)UILabel *study;
@property (strong ,nonatomic)UILabel *studyNum;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDic:(NSDictionary *)dict;

@end
