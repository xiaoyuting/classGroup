//
//  GLLiveTableViewCell.h
//  dafengche
//
//  Created by IOS on 17/2/22.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLLiveTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UIButton *playButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UIButton *audition;

@property (strong ,nonatomic)UILabel *teacherLabel;

@property (strong ,nonatomic)UILabel *studyNum;

@property (strong ,nonatomic)UILabel *kinsOf;

@property (strong ,nonatomic)UILabel *XBLabel;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UILabel *GKLabel;

@property (strong ,nonatomic)UILabel *OrderLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type;


@end
