//
//  ClassDetailRecommendCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassDetailRecommendCell : UITableViewCell


@property (strong ,nonatomic)UILabel *bar;
@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UIButton *headerImage;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *person;
@property (strong ,nonatomic)UIButton *imageButton1;
@property (strong ,nonatomic)UIButton *imageButton2;
@property (strong ,nonatomic)UIButton *imageButton3;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDic:(NSDictionary *)dict;

@end
